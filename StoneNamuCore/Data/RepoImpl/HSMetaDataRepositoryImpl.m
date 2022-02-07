//
//  HSMetaDataRepositoryImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import "HSMetaDataRepositoryImpl.h"
#import <StoneNamuCore/BlizzardAPIRepositoryImpl.h>

static NSString * const BlizzardHSMetaDataAPIBasePath = @"/hearthstone/metadata";

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
        
        NSError * _Nullable parseError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&parseError];
        
        if (parseError) {
            completion(nil, error);
            return;
        }
        
        HSMetaData *hsMetaData = [HSMetaData hsCardMetaDataFromDic:dic error:&parseError];
        
        if (parseError) {
            completion(nil, error);
            return;
        }
        
        completion(hsMetaData, nil);
    };
    
    [self.blizzardHSRepository getAtRegion:regionHost
                                      path:BlizzardHSMetaDataAPIBasePath
                                   options:options
                         completionHandler:hsAPICompletion];
}

@end
