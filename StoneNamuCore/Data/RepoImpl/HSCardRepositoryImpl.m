//
//  HSCardRepositoryImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "HSCardRepositoryImpl.h"
#import "BlizzardAPIRepositoryImpl.h"

static NSString * const BlizzardHSCardAPIBasePath = @"/hearthstone/cards";

@interface HSCardRepositoryImpl ()
@property (retain) id<BlizzardAPIRepository> blizzardHSRepository;
@end

@implementation HSCardRepositoryImpl

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

- (void)fetchCardsAtRegion:(BlizzardAPIRegionHost)regionHost
               withOptions:(NSDictionary<NSString *, id> * _Nullable)options
         completionHandler:(HSCardRepositoryCardsCompletion)completion
{
    BlizzardAPIRepositoryCompletion hsAPICompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            completion(nil, nil, nil, error);
            return;
        }
        
        NSError * _Nullable parseError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
        if (parseError) {
            completion(nil, nil, nil, parseError);
        }
        
        NSArray<HSCard *> *hsCards = [HSCard hsCardsFromDic:dic];
        NSNumber * _Nullable pageCount = dic[@"pageCount"];
        NSNumber * _Nullable page = dic[@"page"];
        
        completion(hsCards, pageCount, page, nil);
    };
    
    [self.blizzardHSRepository getAtRegion:regionHost
                                      path:BlizzardHSCardAPIBasePath
                                   options:options
                         completionHandler:hsAPICompletion];
}

- (void)fetchCardAtRegion:(BlizzardAPIRegionHost)regionHost
              withIdOrSlug:(NSString *)idOrSlug
               withOptions:(NSDictionary<NSString *, id> * _Nullable)options
         completionHandler:(HSCardRepositoryCardCompletion)completion {
    
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
        }
        
        HSCard *hsCard = [HSCard hsCardFromDic:dic];
        
        completion(hsCard, nil);
    };
    
    [self.blizzardHSRepository getAtRegion:regionHost
                                      path:[NSString stringWithFormat:@"%@/%@", BlizzardHSCardAPIBasePath, idOrSlug]
                                   options:options
                         completionHandler:hsAPICompletion];
}

@end
