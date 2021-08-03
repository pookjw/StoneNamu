//
//  DataCacheUseCaseImpl.m
//  DataCacheUseCaseImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "DataCacheUseCaseImpl.h"
#import "DataCacheRepositoryImpl.h"

@interface DataCacheUseCaseImpl ()
@property (retain) id<DataCacheRepository> dataCacheRepository;
@end

@implementation DataCacheUseCaseImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        DataCacheRepositoryImpl *dataCacheRepository = [DataCacheRepositoryImpl new];
        self.dataCacheRepository = dataCacheRepository;
        [dataCacheRepository release];
    }
    
    return self;
}

- (void)dealloc {
    [_dataCacheRepository release];
    [super dealloc];
}

- (void)dataCachesWithIdentity:(NSString *)identity completion:(DataCacheUseCaseFetchWithIdentityCompletion)completion {
    [self.dataCacheRepository dataCachesWithIdentity:identity completion:^(NSArray<DataCache *> * dataCaches) {
        
        NSMutableArray<NSData *> *mutable = [@[] mutableCopy];
        
        for (DataCache *dataCache in dataCaches) {
            if (dataCache.data) {
                [mutable addObject:dataCache.data];
            }
        }
        
        NSArray *results = [[mutable copy] autorelease];
        [mutable release];
        
        completion(results);
    }];
}

- (void)removeAllDataCaches {
    [self.dataCacheRepository removeAllDataCaches];
}

- (void)createDataCache:(NSData *)data identity:(NSString *)identity {
    DataCache *dataCache = [self.dataCacheRepository createDataCache];
    dataCache.data = data;
    dataCache.identity = identity;
    [self.dataCacheRepository saveChanges];
}


@end
