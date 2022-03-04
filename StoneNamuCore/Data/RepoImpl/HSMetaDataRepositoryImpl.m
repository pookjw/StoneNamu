//
//  HSMetaDataRepositoryImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import "HSMetaDataRepositoryImpl.h"
#import <StoneNamuCore/BlizzardAPIRepositoryImpl.h>

static NSString * const BlizzardHSMetaDataAPIBasePath = @"/hearthstone/metadata";

static HSMetaData * _Nullable cachedHSMetaData = nil;
static NSString * const hsMetaDataUseCaseImplSynchronizedToken = @"hsMetaDataUseCaseImplSynchronizedToken";

@interface HSMetaDataRepositoryImpl ()
@property (retain) id<BlizzardAPIRepository> blizzardHSRepository;
@end

@implementation HSMetaDataRepositoryImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        BlizzardAPIRepositoryImpl *blizzardHSRepository = [BlizzardAPIRepositoryImpl new];
        self.blizzardHSRepository = blizzardHSRepository;
        [blizzardHSRepository release];
    }
    
    return self;
}

- (void)dealloc {
    [_blizzardHSRepository release];
    [super dealloc];
}

- (void)fetchMetaDataAtRegion:(BlizzardAPIRegionHost)regionHost withOptions:(NSDictionary<NSString *,NSString *> *)options completionHandler:(HSMetaDataRepositoryFetchMetaDataCompletion)completion {
    
    BlizzardAPIRepositoryCompletion hsAPICompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSDictionary *dic;
        NSError * _Nullable parseError = nil;
        if (@available(macOS 12.0, iOS 15.0, *)) {
            dic = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingJSON5Allowed
                                                    error:&parseError];
        } else {
            dic = [NSJSONSerialization JSONObjectWithData:data
                                                  options:0
                                                    error:&parseError];
        }
        
        if (parseError) {
            completion(nil, error);
            return;
        }
        
        HSMetaData *hsMetaData = [HSMetaData hsCardMetaDataFromDic:dic error:&parseError];
        
        if (parseError) {
            completion(nil, error);
            return;
        }
        
        @synchronized (hsMetaDataUseCaseImplSynchronizedToken) {
            [cachedHSMetaData release];
            cachedHSMetaData = [hsMetaData retain];
        }
        
        completion(hsMetaData, nil);
    };
    
    @synchronized (hsMetaDataUseCaseImplSynchronizedToken) {
        if (cachedHSMetaData) {
            completion(cachedHSMetaData, nil);
        } else {
            [self.blizzardHSRepository getAtRegion:regionHost
                                              path:BlizzardHSMetaDataAPIBasePath
                                           options:options
                                 completionHandler:hsAPICompletion];
        }
    }
}

- (void)clearCache {
    @synchronized (hsMetaDataUseCaseImplSynchronizedToken) {
        [cachedHSMetaData release];
        cachedHSMetaData = nil;
        
        [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameHSMetaDataRepositoryClearCache
                                                          object:self
                                                        userInfo:nil];
    }
}

@end
