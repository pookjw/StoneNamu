//
//  HSCardBackRepositoryImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 3/5/22.
//

#import <StoneNamuCore/HSCardBackRepositoryImpl.h>
#import <StoneNamuCore/BlizzardAPIRepositoryImpl.h>

static NSString * const BlizzardHSCardBacksAPIBasePath = @"/hearthstone/cardbacks";

@interface HSCardBackRepositoryImpl ()
@property (retain) id<BlizzardAPIRepository> blizzardHSRepository;
@end

@implementation HSCardBackRepositoryImpl

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
         completionHandler:(HSCardBackRepositoryFetchCardBacksCompletion)completion {
    
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
        
        NSError * _Nullable hsCardBackError = nil;
        NSArray<HSCardBack *> *hsCardBacks = [HSCardBack hsCardBacksFromDic:dic error:&hsCardBackError];
        NSNumber * _Nullable pageCount = dic[@"pageCount"];
        NSNumber * _Nullable page = dic[@"page"];
        
        completion(hsCardBacks, pageCount, page, hsCardBackError);
    };
    
    [self.blizzardHSRepository getAtRegion:regionHost
                                      path:BlizzardHSCardBacksAPIBasePath
                                   options:options
                         completionHandler:hsAPICompletion];
}

- (void)fetchCardAtRegion:(BlizzardAPIRegionHost)regionHost
              withIdOrSlug:(NSString *)idOrSlug
               withOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options
        completionHandler:(HSCardBackRepositoryFetchCardBackCompletion)completion {
    
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
        
        NSError * _Nullable hsCardBackError = nil;
        HSCardBack *hsCardBack = [HSCardBack hsCardBackFromDic:dic error:&hsCardBackError];
        
        completion(hsCardBack, hsCardBackError);
    };
    
    [self.blizzardHSRepository getAtRegion:regionHost
                                      path:[NSString stringWithFormat:@"%@/%@", BlizzardHSCardBacksAPIBasePath, idOrSlug]
                                   options:options
                         completionHandler:hsAPICompletion];
}

@end
