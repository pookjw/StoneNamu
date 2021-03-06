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
        
        NSMutableArray<NSData *> *results = [NSMutableArray<NSData *> new];
        
        for (DataCache *dataCache in dataCaches) {
            if (dataCache.data) {
                [results addObject:dataCache.data];
            }
        }
        
        completion([results autorelease], nil);
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
        [self.dataCacheRepository saveChanges];
        completion();
    }];
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(deleteAllEventReceived:)
                                               name:NSNotificationNameDataCacheRepositoryDeleteAll
                                             object:self.dataCacheRepository];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(changesReceived:)
                                               name:NSNotificationNameDataCacheRepositoryObserveData
                                             object:self.dataCacheRepository];
}

- (void)deleteAllEventReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDataCacheUseCaseDeleteAll
                                                      object:self
                                                    userInfo:nil];
}

- (void)changesReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDataCacheUseCaseObserveData
                                                      object:self
                                                    userInfo:nil];
}

@end
