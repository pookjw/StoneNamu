//
//  HSCardRepositoryImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <StoneNamuCore/HSCardRepositoryImpl.h>
#import <StoneNamuCore/BlizzardAPIRepositoryImpl.h>
#import <StoneNamuCore/HearthStoneRapidAPIImpl.h>

static NSString * const BlizzardHSCardAPIBasePath = @"/hearthstone/cards";

static NSData * _Nullable cache = nil;

@interface HSCardRepositoryImpl ()
@property (retain) id<BlizzardAPIRepository> blizzardHSRepository;
@property (retain) id<HearthStoneRapidAPI> hearthStoneRapidAPI;
@end

@implementation HSCardRepositoryImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        BlizzardAPIRepositoryImpl *blizzardHSRepository = [BlizzardAPIRepositoryImpl new];
        self.blizzardHSRepository = blizzardHSRepository;
        [blizzardHSRepository release];
        
        HearthStoneRapidAPIImpl *hearthStoneRapidAPI = [HearthStoneRapidAPIImpl new];
        self.hearthStoneRapidAPI = hearthStoneRapidAPI;
        [hearthStoneRapidAPI release];
    }
    
    return self;
}

- (void)dealloc {
    [_blizzardHSRepository release];
    [_hearthStoneRapidAPI release];
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
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&parseError];
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
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&parseError];
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

- (void)getAllInternalCardIdsWithCompletionHandler:(HSCardRepositoryGetAllInternalCardIdsCompletion)completion {
    
    HearthStoneRapidAPICompletion hsAPICompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        if (cache == nil) {
            cache = [data retain];
        }
        
        NSError * _Nullable parseError = nil;
        NSDictionary<NSString *, NSArray<NSDictionary<NSString *, NSString *> *> *> *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                           options:NSJSONReadingMutableContainers
                                                                                                                             error:&parseError];
        if (parseError) {
            completion(nil, parseError);
            return;
        }
        
        NSMutableDictionary<NSNumber *, NSString *> *results = [NSMutableDictionary<NSNumber *, NSString *> new];
        
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray<NSDictionary<NSString *,NSString *> *> * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSNumber *dbfId = [NSNumber numberWithInteger:obj[@"dbfId"].integerValue];
                NSString *cardId = obj[@"cardId"];
                results[dbfId] = cardId;
            }];
        }];
        
        completion([results autorelease], nil);
    };
    
    if (cache) {
        hsAPICompletion(cache, nil, nil);
    } else {
        [self.hearthStoneRapidAPI getWithPath:@"/cards" completionHandler:hsAPICompletion];
    }
}

@end
