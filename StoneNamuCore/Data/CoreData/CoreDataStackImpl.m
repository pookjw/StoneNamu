//
//  CoreDataStackImpl.m
//  CoreDataStackImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "CoreDataStackImpl.h"

static NSMutableDictionary<NSString *, NSPersistentContainer *> * _Nullable kStoreContainers = nil;
static NSMutableDictionary<NSString *, NSManagedObjectContext *> * _Nullable kContexts = nil;
static NSMutableDictionary<NSString *, NSOperationQueue *> * _Nullable kOperationQueues = nil;

@interface CoreDataStackImpl () {
    NSManagedObjectContext *_context;
    NSPersistentContainer *_storeContainer;
    NSOperationQueue *_queue;
}

@end

@implementation CoreDataStackImpl

@synthesize context = _context;
@synthesize storeContainer = _storeContainer;
@synthesize queue = _queue;

- (instancetype)initWithModelName:(NSString *)modelName storeContainerClass:(Class)storeContainerClass {
    self = [self init];
    
    if (self) {
        [self configureStoreContainerWithModelName:modelName class:storeContainerClass];
        [self configureContextWithModelName:modelName];
        [self configureQueueWithModelName:modelName];
        [self bind];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
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
        
        NSError * _Nullable error = nil;
        [self.context save:&error];
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)configureStoreContainerWithModelName:(NSString *)modelName class:(Class)class {
    if (kStoreContainers == nil) {
        kStoreContainers = [@{} mutableCopy];
    }
    
    if (kStoreContainers[modelName]) {
        _storeContainer = [kStoreContainers[modelName] retain];
        return;
    }
    
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.pookjw.StoneNamuCore"];
    NSURL *modelURL = [bundle URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentContainer *container = [class persistentContainerWithName:modelName managedObjectModel:model];
    [model release];
    
    [container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull description, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    kStoreContainers[modelName] = container;
    _storeContainer = [container retain];
}

- (void)configureContextWithModelName:(NSString *)modelName {
    if (kContexts == nil) {
        kContexts = [@{} mutableCopy];
    }
    
    if (kContexts[modelName] == nil) {
        kContexts[modelName] = self.storeContainer.newBackgroundContext;
    }
    
    _context = [kContexts[modelName] retain];
}

- (void)configureQueueWithModelName:(NSString *)modelName {
    if (kOperationQueues == nil) {
        kOperationQueues = [@{} mutableCopy];
    }
    
    if (kOperationQueues[modelName]) {
        _queue = [kOperationQueues[modelName] retain];
    }
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.qualityOfService = NSQualityOfServiceUserInitiated;
    kOperationQueues[modelName] = queue;
    _queue = [queue retain];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveChangeEvent:)
                                               name:NSManagedObjectContextDidSaveNotification
                                             object:self.context];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveChangeEvent:)
                                               name:NSPersistentCloudKitContainerEventChangedNotification
                                             object:self.storeContainer];
}

- (void)didReceiveChangeEvent:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:CoreDataStackDidChangeNotificationName
                                                      object:self
                                                    userInfo:nil];
}

@end
