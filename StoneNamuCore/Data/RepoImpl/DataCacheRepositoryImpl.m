//
//  DataCacheRepositoryImpl.m
//  DataCacheRepositoryImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <StoneNamuCore/DataCacheRepositoryImpl.h>
#import <StoneNamuCore/CoreDataStackImpl.h>
#import <StoneNamuCore/DataCache.h>
#import <StoneNamuCore/NSManagedObject+_fetchRequest.h>

@interface DataCacheRepositoryImpl ()
@property (retain) id<CoreDataStack> coreDataStack;
@end

@implementation DataCacheRepositoryImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        CoreDataStackImpl *coreDataStack = [[CoreDataStackImpl alloc] initWithModelName:@"DataCacheModel" storeContainerClass:[NSPersistentContainer class] models:@[@"DataCacheModel"]];
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

- (void)fileSizeWithCompletion:(DataCacheRepositoryFileSizeWithCompletion)completion {
    [self.coreDataStack.queue addOperationWithBlock:^{
        NSURL *url = self.coreDataStack.storeContainer.persistentStoreCoordinator.persistentStores.firstObject.URL;
        NSError * _Nullable error = nil;
        NSDictionary *attributes = [NSFileManager.defaultManager attributesOfItemAtPath:url.path error:&error];
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completion([NSNumber numberWithLongLong:0]);
            return;
        }
        
        NSNumber *fileSize = attributes[NSFileSize];
        completion(fileSize);
    }];
}

- (void)saveChanges {
    [self.coreDataStack saveChanges];
}

- (void)dataCachesWithIdentity:(NSString *)identity completion:(DataCacheRepositoryFetchWithIdentityCompletion)completion {
    if (identity == nil) return;
    
    [self.coreDataStack.queue addOperationWithBlock:^{
        NSManagedObjectContext *context = self.coreDataStack.context;
        
        [context performBlockAndWait:^{
            @autoreleasepool {
                NSFetchRequest *fetchRequest = DataCache._fetchRequest;
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@" argumentArray:@[@"identity", identity]];
                fetchRequest.predicate = predicate;
                
                NSError * _Nullable error = nil;
                NSArray<DataCache *> *results = [context executeFetchRequest:fetchRequest error:&error];
                
                if (error) {
                    completion(nil, error);
                    return;
                }
                
                completion(results, nil);
            }
        }];
    }];
}

- (void)deleteAllDataCaches {
    [self.coreDataStack.queue addBarrierBlock:^{
        NSManagedObjectContext *context = self.coreDataStack.context;
        
        [context performBlockAndWait:^{
            @autoreleasepool {
                NSFetchRequest *fetchRequest = DataCache._fetchRequest;
                NSBatchDeleteRequest *batchDelete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
                batchDelete.affectedStores = self.coreDataStack.storeContainer.persistentStoreCoordinator.persistentStores;
                
                NSError * _Nullable error = nil;
                [self.coreDataStack.storeContainer.persistentStoreCoordinator executeRequest:batchDelete withContext:context error:&error];
                [batchDelete release];
                
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                } else {
                    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDataCacheRepositoryDeleteAll
                                                                      object:self
                                                                    userInfo:nil];
                    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDataCacheRepositoryObserveData
                                                                      object:self
                                                                    userInfo:nil];
                }
            }
        }];
    }];
}

- (void)makeDataCacheWithCompletion:(DataCacheRepositoryMakeWithCompletion)completion {
    [self.coreDataStack.queue addBarrierBlock:^{
        DataCache *dataCache = [[DataCache alloc] initWithContext:self.coreDataStack.context];
        completion([dataCache autorelease]);
    }];
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(changesReceived:)
                                               name:NSNotificationNameCoreDataStackDidChange
                                             object:nil];
}

- (void)changesReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDataCacheRepositoryObserveData
                                                      object:self
                                                    userInfo:nil];
}

@end
