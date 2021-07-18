//
//  HSCardRepositoryImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "HSCardRepositoryImpl.h"
#import "BlizzardHSRepositoryImpl.h"

static NSString * const BlizzardHSCardAPIBasePath = @"/hearthstone/cards";

@interface HSCardRepositoryImpl ()
@property (retain) NSObject<BlizzardHSRepository> *blizzardHSRepository;
@end

@implementation HSCardRepositoryImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        BlizzardHSRepositoryImpl *blizzardHSRepository = [BlizzardHSRepositoryImpl new];
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
               withOptions:(NSDictionary<NSString *, id> *)options
         completionHandler:(HSCardRepositoryCardsCompletion)completion
{
    BlizzardHSRepositoryCompletion hsAPICompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSError * _Nullable hsCardError = nil;
        NSArray<HSCard *> *hsCards = [HSCard hsCardsFromJSONData:data error:&hsCardError];
        
        if (hsCardError) {
            completion(nil, hsCardError);
        }
        
        completion(hsCards, nil);
    };
    
    [self.blizzardHSRepository getAtRegion:regionHost
                                      path:BlizzardHSCardAPIBasePath
                                   options:options
                         completionHandler:hsAPICompletion];
}

@end
