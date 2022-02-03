//
//  CoreDataStackImpl.m
//  CoreDataStackImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <StoneNamuCore/CoreDataStackImpl.h>
#import <StoneNamuCore/SemaphoreCondition.h>
#import <StoneNamuCore/Identifier.h>
#import <StoneNamuCore/NSDictionary+combine.h>

static NSDictionary<NSString *, NSPersistentContainer *> *kStoreContainers = @{};
static NSDictionary<NSString *, NSManagedObjectContext *> *kContexts = @{};
static NSDictionary<NSString *, NSOperationQueue *> *kOperationQueues = @{};
static NSDictionary<NSString *, NSNumber *> *kMigrateStatus = @{};

@interface CoreDataStackImpl () {
    NSManagedObjectContext *_context;
    NSPersistentContainer *_storeContainer;
    NSOperationQueue *_queue;
}
@property Class storeContainerClass;
@end

@implementation CoreDataStackImpl

@synthesize context = _context;
@synthesize storeContainer = _storeContainer;
@synthesize queue = _queue;

- (instancetype)initWithModelName:(NSString *)modelName storeContainerClass:(Class)storeContainerClass models:(nonnull NSArray<NSString *> *)models {
    if (!NSThread.isMainThread) {
        [NSException raise:@"Not Main Thread!" format:@"Please run init at Main Thread!"];
    }
    
    self = [self init];
    
    if (self) {
        self.storeContainerClass = storeContainerClass;
        [self configureStoreContainerWithModelName:modelName models:models class:storeContainerClass];
        [self configureContextWithModelName:modelName];
        [self configureQueueWithModelName:modelName];
        [self performMigrationIfNeededWithModelName:modelName models:models];
        [self bind];
    }
    
    return self;
}

- (void)dealloc {
    [_context release];
    [_storeContainer release];
    [_queue release];
    [super dealloc];
}

- (void)saveChanges {
    [self.queue addBarrierBlock:^{
        if (!self.context.hasChanges) {
            NSLog(@"Nothing to save!");
            return;
        }
        
        [self.context performBlockAndWait:^{
            @autoreleasepool {
                NSError * _Nullable error = nil;
                [self.context save:&error];
                
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                }
            }
        }];
    }];
}

- (void)configureStoreContainerWithModelName:(NSString *)modelName models:(nonnull NSArray<NSString *> *)models class:(Class)class {
    if (kStoreContainers[modelName]) {
        [self->_storeContainer release];
        self->_storeContainer = [kStoreContainers[modelName] retain];
        return;
    }
    
    NSManagedObjectModel *model = [self modelForMomd:modelName mom:models.lastObject];
    NSPersistentContainer *container = [class persistentContainerWithName:modelName managedObjectModel:model];
    
    SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:0];
    
    [container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull description, NSError * _Nullable error) {
        [semaphore signal];
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [semaphore wait];
    [semaphore release];
    
    NSDictionary<NSString *, NSPersistentContainer *> *new = [kStoreContainers dictionaryByAddingKey:modelName value:container shouldOverride:YES];
    [kStoreContainers release];
    kStoreContainers = [new copy];
    [self->_storeContainer release];
    self->_storeContainer = [container retain];
}

- (void)configureContextWithModelName:(NSString *)modelName {
    if (kContexts[modelName]) {
        [self->_context release];
        self->_context = [kContexts[modelName] retain];
        return;
    }
    
    NSManagedObjectContext *context = self.storeContainer.newBackgroundContext;
    context.automaticallyMergesChangesFromParent = YES;
    
    NSDictionary<NSString *, NSManagedObjectContext *> *new = [kContexts dictionaryByAddingKey:modelName value:context shouldOverride:YES];
    [kContexts release];
    kContexts = [new copy];
    [self->_context release];
    self->_context = [context retain];
}

- (void)configureQueueWithModelName:(NSString *)modelName {
    if (kOperationQueues == nil) {
        kOperationQueues = [@{} mutableCopy];
    }
    
    if (kOperationQueues[modelName]) {
        [self->_queue release];
        self->_queue = [kOperationQueues[modelName] retain];
        return;
    }
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.qualityOfService = NSQualityOfServiceUserInitiated;
    
    NSDictionary<NSString *, NSOperationQueue *> *new = [kOperationQueues dictionaryByAddingKey:modelName value:queue shouldOverride:YES];
    [kOperationQueues release];
    kOperationQueues = [new copy];
    [self->_queue release];
    self->_queue = [queue retain];
    [queue release];
}

- (void)performMigrationIfNeededWithModelName:(NSString *)modelName models:(nonnull NSArray<NSString *> *)models {
    if (models.count < 2) return;
    
    NSNumber * _Nullable status = kMigrateStatus[modelName];
    
    if ((status != nil) && (status.boolValue)) {
        return;
    }
    
    //
    
    SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:0];
    
    [self.queue addBarrierBlock:^{
        for (NSUInteger index = 0; index < (models.count - 1); index++) {
            NSManagedObjectModel *currentmodel = [self modelForMomd:modelName mom:models[index]];
            NSManagedObjectModel *nextModel = [self modelForMomd:modelName mom:models[index + 1]];
            
            if ((currentmodel == nil) || (nextModel == nil)) {
                continue;
            }
            
            NSMigrationManager *migrationManager = [[NSMigrationManager alloc] initWithSourceModel:currentmodel destinationModel:nextModel];
            NSMappingModel *mappingModel = [NSMappingModel inferredMappingModelForSourceModel:currentmodel destinationModel:nextModel error:nil];
            
            NSURL *dirURL = [self.storeContainerClass defaultDirectoryURL];
            NSURL *fromURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@.sqlite", modelName] relativeToURL:dirURL];
            NSURL *toDestinationURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@_migration.sqlite", modelName] relativeToURL:dirURL];
            
            [NSFileManager.defaultManager removeItemAtURL:toDestinationURL error:nil];
            
            NSError * _Nullable error = nil;
            [migrationManager migrateStoreFromURL:fromURL
                                             type:NSSQLiteStoreType
                                          options:nil
                                 withMappingModel:mappingModel
                                 toDestinationURL:toDestinationURL
                                  destinationType:NSSQLiteStoreType
                               destinationOptions:nil
                                            error:&error];
            
            [migrationManager release];
            
            if (error == nil) {
                [NSFileManager.defaultManager removeItemAtURL:fromURL error:nil];
                [NSFileManager.defaultManager moveItemAtURL:toDestinationURL toURL:fromURL error:nil];
            } else {
//                NSLog(@"Migration failed: %@", error.localizedDescription);
            }
        }
        
        [semaphore signal];
    }];
    
    [semaphore wait];
    [semaphore release];
    
    NSDictionary<NSString *, NSNumber *> *new = [kMigrateStatus dictionaryByAddingKey:models value:[NSNumber numberWithBool:YES] shouldOverride:YES];
    [kMigrateStatus release];
    kMigrateStatus = [new copy];
}

- (NSManagedObjectModel * _Nullable)modelForMomd:(NSString *)modelName mom:(NSString *)mom {
    NSBundle *bundle = [NSBundle bundleWithIdentifier:IDENTIFIER];
    NSArray<NSURL *> *urls = [bundle URLsForResourcesWithExtension:@"mom" subdirectory:[NSString stringWithFormat:@"%@.momd", modelName]];
    NSURL * _Nullable __block url = nil;
    
    [urls enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.lastPathComponent isEqualToString:[NSString stringWithFormat:@"%@.mom", mom]]) {
            url = obj;
            *stop = YES;
        }
    }];
    
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    
    return [model autorelease];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveSave:)
                                               name:NSManagedObjectContextDidSaveNotification
                                             object:self.context];
    
    if ([self.storeContainer isKindOfClass:[NSPersistentCloudKitContainer class]]) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(didReceiveChangesOfCloud:)
                                                   name:NSPersistentCloudKitContainerEventChangedNotification
                                                 object:self.storeContainer];
    }
}

- (void)didReceiveSave:(NSNotification *)notification {
    [self postChangedNotification];
}

- (void)didReceiveChangesOfCloud:(NSNotification *)notification {
    NSPersistentCloudKitContainerEvent * _Nullable event = notification.userInfo[NSPersistentCloudKitContainerEventUserInfoKey];
    
    if (event == nil) return;
    
    if ((event.succeeded) && (event.type == NSPersistentCloudKitContainerEventTypeExport)) {
        [self postChangedNotification];
    }
}

- (void)postChangedNotification {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCoreDataStackDidChange
                                                      object:self
                                                    userInfo:nil];
}

@end
