//
//  DataCacheUseCaseImpl.m
//  DataCacheUseCaseImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <StoneNamuCore/DataCacheUseCaseImpl.h>
#import <StoneNamuCore/DataCacheRepositoryImpl.h>

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
        
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_dataCacheRepository release];
    [super dealloc];
}

- (void)dataCachesWithIdentity:(NSString *)identity completion:(DataCacheUseCaseFetchWithIdentityCompletion)completion {
    [self.dataCacheRepository dataCachesWithIdentity:identity completion:^(NSArray<DataCache *> * _Nullable dataCaches, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSMutableArray<NSData *> *mutable = [@[] mutableCopy];
        
        for (DataCache *dataCache in dataCaches) {
            if (dataCache.data) {
                [mutable addObject:dataCache.data];
            }
        }
        
        NSArray *results = [[mutable copy] autorelease];
        [mutable release];
        
        completion(results, nil);
    }];
}

- (void)deleteAllDataCaches {
    [self.dataCacheRepository deleteAllDataCaches];
}

- (void)fileSizeWithCompletion:(DataCacheUseCaseFileSizeWithCompletion)completion {
    [self.dataCacheRepository fileSizeWithCompletion:completion];
}

- (void)makeDataCache:(NSData *)data identity:(NSString *)identity completion:(DataCacheUseCaseMakeWithCompletion)completion {
    [self.dataCacheRepository makeDataCacheWithCompletion:^(DataCache * _Nonnull dataCache) {
        dataCache.data = data;
        dataCache.identity = identity;
        completion();
    }];
}

- (void)saveChanges {
    [self.dataCacheRepository saveChanges];
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(deleteAllEventReceived:)
                                               name:DataCacheRepositoryDeleteAllNotificationName
                                             object:self.dataCacheRepository];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(changesReceived:)
                                               name:DataCacheRepositoryObserveDataNotificationName
                                             object:self.dataCacheRepository];
}

- (void)deleteAllEventReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:DataCacheUseCaseDeleteAllNotificationName
                                                      object:self
                                                    userInfo:nil];
}

- (void)changesReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:DataCacheUseCaseObserveDataNotificationName
                                                      object:self
                                                    userInfo:nil];
}

@end
