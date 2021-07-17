//
//  BlizzardHSRepositoryImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "BlizzardHSRepositoryImpl.h"
#import "BlizzardTokenAPIImpl.h"
#import "BlizzardHSAPIImpl.h"

@interface BlizzardHSRepositoryImpl ()
@property (retain) NSObject<BlizzardTokenAPI> *blizzardTokenAPI;
@property (retain) NSObject<BlizzardHSAPI> *blizzardHSAPI;
@end

@implementation BlizzardHSRepositoryImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        BlizzardTokenAPIImpl *blizzardTokenAPI = [BlizzardTokenAPIImpl new];
        self.blizzardTokenAPI = blizzardTokenAPI;
        [blizzardTokenAPI release];
        
        BlizzardHSAPIImpl *blizzardHSAPI = [BlizzardHSAPIImpl new];
        self.blizzardHSAPI = blizzardHSAPI;
        [blizzardHSAPI release];
    }
    
    return self;
}

- (void)dealloc {
    [_blizzardTokenAPI release];
    [_blizzardHSAPI release];
    [super dealloc];
}

- (void)fetchCardsAtRegion:(BlizzardAPIRegionHost)regionHost
               withOptions:(NSDictionary<NSString *, id> *)options
          completionHandler:(BlizzardHSRepositoryCardsCompletion)completion
{
    BlizzardHSAPICompletionType hsAPICompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
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
    
    BlizzardTokenAPICompletionType tokenAPICompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSError * _Nullable jsonError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

        if (jsonError) {
            completion(nil, jsonError);
            return;
        }
        
        NSString * _Nullable token = dic[@"access_token"];
        
        [self.blizzardHSAPI fetchCardsAtRegion:regionHost
                                   accessToken:token
                                       options:options
                             completionHandler:hsAPICompletion];
    };
    
    [self.blizzardTokenAPI getAccessTokenAtRegion:regionHost
                                completionHandler:tokenAPICompletion];
}

@end
