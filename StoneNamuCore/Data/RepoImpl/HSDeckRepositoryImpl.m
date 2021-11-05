//
//  HSDeckRepositoryImpl.m
//  HSDeckRepositoryImpl
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <StoneNamuCore/HSDeckRepositoryImpl.h>
#import <StoneNamuCore/BlizzardAPIRepositoryImpl.h>

static NSString * const BlizzardHSDeckAPIBasePath = @"/hearthstone/deck";

@interface HSDeckRepositoryImpl ()
@property (retain) id<BlizzardAPIRepository> blizzardHSRepository;
@end

@implementation HSDeckRepositoryImpl

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

- (void)fetchDeckAtRegion:(BlizzardAPIRegionHost)regionHost withOptions:(NSDictionary<NSString *,NSString *> *)options completion:(HSDeckRepositoryFetchDeckCompletion)completion {
    
    BlizzardAPIRepositoryCompletion hsAPICompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSError * _Nullable parseError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
        if (parseError) {
            completion(nil, parseError);
            return;
        }
        
        NSError * _Nullable deckError = nil;
        HSDeck *hsDeck = [HSDeck hsDeckFromDic:dic error:&deckError];
        
        completion(hsDeck, deckError);
    };
    
    [self.blizzardHSRepository getAtRegion:regionHost
                                      path:BlizzardHSDeckAPIBasePath
                                   options:options
                         completionHandler:hsAPICompletion];
}

@end
