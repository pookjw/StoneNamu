//
//  DataCacheRepositoryImpl.m
//  DataCacheRepositoryImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "DataCacheRepositoryImpl.h"
#import "CoreDataStackImpl.h"
#import "DataCache.h"

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

- (NSArray<DataCache *> *)dataCachesWithIdentity:(NSString *)identity {
    NSManagedObjectContext *mainContext = self.coreDataStack.mainContext;
    NSFetchRequest *fetchRequest = DataCache._fetchRequest;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@" argumentArray:@[@"identity", identity]];
    fetchRequest.predicate = predicate;
    
    NSError * _Nullable error = nil;
    NSArray<DataCache *> *results = [mainContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    return results;
}

- (void)removeAllDataCaches {
    NSFetchRequest *fetchRequest = DataCache._fetchRequest;
    NSBatchDeleteRequest *batchDelete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    batchDelete.affectedStores = self.coreDataStack.storeContainer.persistentStoreCoordinator.persistentStores;
    
    NSError * _Nullable error = nil;
    [self.coreDataStack.mainContext executeRequest:batchDelete error:&error];
    [batchDelete release];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
}

- (DataCache *)createDataCache {
    DataCache *dataCache = [[[DataCache alloc] initWithContext:self.coreDataStack.mainContext] autorelease];
    return dataCache;
}

@end