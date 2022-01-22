//
//  LocalDeckRepositoryImpl.m
//  LocalDeckRepositoryImpl
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <StoneNamuCore/LocalDeckRepositoryImpl.h>
#import <StoneNamuCore/CoreDataStackImpl.h>
#import <StoneNamuCore/NSManagedObject+_fetchRequest.h>

@interface LocalDeckRepositoryImpl ()
@property (retain) id<CoreDataStack> coreDataStack;
@end

@implementation LocalDeckRepositoryImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        CoreDataStackImpl *coreDataStack = [[CoreDataStackImpl alloc] initWithModelName:@"LocalDeckModel" storeContainerClass:[NSPersistentCloudKitContainer class] models:@[@"LocalDeckModel", @"LocalDeckModel 2"]];
        self.coreDataStack = coreDataStack;
        [coreDataStack release];
        
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_coreDataStack release];
    [super dealloc];
}

- (NSOperationQueue *)queue {
    return self.coreDataStack.queue;
}

- (void)deleteLocalDecks:(NSSet<LocalDeck *> *)localDecks {
    [self.queue addBarrierBlock:^{
        NSManagedObjectContext *context = self.coreDataStack.context;
        
        [context performBlockAndWait:^{
            [localDecks enumerateObjectsUsingBlock:^(LocalDeck * _Nonnull obj, BOOL * _Nonnull stop) {
                [context deleteObject:obj];
            }];
        }];
        
        [self saveChanges];
    }];
}

- (void)deleteAllLocalDecks {
    [self.queue addBarrierBlock:^{
        NSManagedObjectContext *context = self.coreDataStack.context;
        
        [context performBlockAndWait:^{
            @autoreleasepool {
                NSFetchRequest *fetchRequest = LocalDeck._fetchRequest;
                NSBatchDeleteRequest *batchDelete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
                batchDelete.affectedStores = self.coreDataStack.storeContainer.persistentStoreCoordinator.persistentStores;
                
                NSError * _Nullable error = nil;
                [self.coreDataStack.storeContainer.persistentStoreCoordinator executeRequest:batchDelete withContext:context error:&error];
                [batchDelete release];
                
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                } else {
                    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameLocalDeckRepositoryDeleteAll
                                                                      object:self
                                                                    userInfo:nil];
                }
            }
        }];
    }];
}

- (void)fetchWithCompletion:(nonnull LocalDeckRepositoryFetchWithCompletion)completion {
    [self.queue addBarrierBlock:^{
        NSManagedObjectContext *context = self.coreDataStack.context;
        
        [context performBlockAndWait:^{
            @autoreleasepool {
                NSFetchRequest *fetchRequest = LocalDeck._fetchRequest;
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
                fetchRequest.sortDescriptors = @[sortDescriptor];
                [sortDescriptor release];
                
                NSError * _Nullable error = nil;
                NSArray<LocalDeck *> *results = [context executeFetchRequest:fetchRequest error:&error];
                
                if (error) {
                    completion(nil, error);
                    return;
                }
                
                completion(results, nil);
            }
        }];
    }];
}

- (void)fetchUsingURI:(NSURL *)uri completion:(LocalDeckRepositoryFetchWithCompletion)completion {
    [self.queue addBarrierBlock:^{
        NSManagedObjectContext *context = self.coreDataStack.context;
        
        [context performBlockAndWait:^{
            NSManagedObjectID * _Nullable objectId = [context.persistentStoreCoordinator managedObjectIDForURIRepresentation:uri];
            
            if (objectId == nil) {
                completion(nil, nil);
                return;
            }
            
            NSError * _Nullable error = nil;
            LocalDeck * _Nullable localDeck = [context existingObjectWithID:objectId error:&error];
            
            if (error != nil) {
                completion(nil, error);
                return;
            }
            
            completion(@[localDeck], nil);
        }];
    }];
}

- (void)refreshObject:(NSManagedObject *)object mergeChanges:(BOOL)flag completion:(nonnull LocalDeckRepositoryRefreshObjectCompletion)completion {
    [self.queue addBarrierBlock:^{
        NSManagedObjectContext *context = self.coreDataStack.context;
        
        [context performBlockAndWait:^{
            [context refreshObject:object mergeChanges:flag];
            completion();
        }];
    }];
}

- (void)makeLocalDeckWithCompletion:(LocalDeckRepositoryMakeWithCompletion)completion {
    [self.coreDataStack.queue addBarrierBlock:^{
        LocalDeck *localDeck = [[[LocalDeck alloc] initWithContext:self.coreDataStack.context] autorelease];
        completion(localDeck);
    }];
}

- (void)saveChanges {
    [self.coreDataStack saveChanges];
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(changesReceived:)
                                               name:NSNotificationNameCoreDataStackDidChange
                                             object:self.coreDataStack];
}

- (void)changesReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameLocalDeckRepositoryObserveData
                                                      object:self
                                                    userInfo:nil];
}

@end
