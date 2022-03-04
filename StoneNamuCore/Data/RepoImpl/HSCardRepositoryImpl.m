//
//  HSCardRepositoryImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <StoneNamuCore/HSCardRepositoryImpl.h>
#import <StoneNamuCore/BlizzardAPIRepositoryImpl.h>

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
               withOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options
         completionHandler:(HSCardRepositoryFetchCardsCompletion)completion {
    
    BlizzardAPIRepositoryCompletion hsAPICompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            completion(nil, nil, nil, error);
            return;
        }
        
        NSError * _Nullable parseError = nil;
        NSDictionary *dic;
        
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
            completion(nil, nil, nil, parseError);
            return;
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
         completionHandler:(HSCardRepositoryFetchCardCompletion)completion {
    
    BlizzardAPIRepositoryCompletion hsAPICompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSError * _Nullable parseError = nil;
        NSDictionary *dic;
        
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
            completion(nil, parseError);
            return;
        }
        
        NSError * _Nullable cardError = nil;
        HSCard *hsCard = [HSCard hsCardFromDic:dic error:&cardError];
        
        completion(hsCard, cardError);
    };
    
    [self.blizzardHSRepository getAtRegion:regionHost
                                      path:[NSString stringWithFormat:@"%@/%@", BlizzardHSCardAPIBasePath, idOrSlug]
                                   options:options
                         completionHandler:hsAPICompletion];
}

@end
