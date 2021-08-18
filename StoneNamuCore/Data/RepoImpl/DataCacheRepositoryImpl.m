//
//  DataCacheRepositoryImpl.m
//  DataCacheRepositoryImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "DataCacheRepositoryImpl.h"
#import "CoreDataStackImpl.h"
#import "DataCache.h"
#import "NSManagedObject+_fetchRequest.h"

@interface DataCacheRepositoryImpl ()
@property (retain) id<CoreDataStack> coreDataStack;
@end

@implementation DataCacheRepositoryImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        CoreDataStackImpl *coreDataStack = [[CoreDataStackImpl alloc] initWithModelName:@"DataCacheModel" storeContainerClass:[NSPersistentContainer class]];
        self.coreDataStack = coreDataStack;
        [coreDataStack release];
    }
    
    return self;
}

- (void)dealloc {
    [_coreDataStack release];
    [super dealloc];
}

- (void)saveChanges {
    [self.coreDataStack saveChanges];
}

- (void)dataCachesWithIdentity:(NSString *)identity completion:(DataCacheRepositoryFetchWithIdentityCompletion)completion {
    [self.coreDataStack.queue addBarrierBlock:^{
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
                    [NSNotificationCenter.defaultCenter postNotificationName:DataCacheRepositoryDeleteAllNotificationName
                                                                      object:self
                                                                    userInfo:nil];
                }
            }
        }];
    }];
}

- (DataCache *)makeDataCache {
    DataCache *dataCache = [[DataCache alloc] initWithContext:self.coreDataStack.context];
    return [dataCache autorelease];
}

@end
