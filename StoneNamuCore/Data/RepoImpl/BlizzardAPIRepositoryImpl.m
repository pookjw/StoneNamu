//
//  BlizzardAPIRepositoryImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <StoneNamuCore/BlizzardAPIRepositoryImpl.h>
#import <StoneNamuCore/BlizzardTokenAPIImpl.h>
#import <StoneNamuCore/BlizzardAPIImpl.h>

@interface BlizzardAPIRepositoryImpl ()
@property (retain) id<BlizzardTokenAPI> blizzardTokenAPI;
@property (retain) id<BlizzardAPI> blizzardHSAPI;
@end

@implementation BlizzardAPIRepositoryImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        BlizzardTokenAPIImpl *blizzardTokenAPI = [BlizzardTokenAPIImpl new];
        self.blizzardTokenAPI = blizzardTokenAPI;
        [blizzardTokenAPI release];
        
        BlizzardAPIImpl *blizzardHSAPI = [BlizzardAPIImpl new];
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

- (void)getAtRegion:(BlizzardAPIRegionHost)regionHost
               path:(NSString *)path
            options:(NSDictionary<NSString *, id> * _Nullable)options
  completionHandler:(BlizzardAPIRepositoryCompletion)completion {
    
    BlizzardAPICompletion hsAPICompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        completion(data, response, error);
    };
    
    BlizzardTokenAPICompletionType tokenAPICompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            completion(data, response, error);
            return;
        }
        
        NSError * _Nullable jsonError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            completion(data, response, jsonError);
            return;
        }
        
        NSString * _Nullable token = dic[@"access_token"];
        
        [self.blizzardHSAPI getAtRegion:regionHost
                                   path:path
                            accessToken:token
                                options:options
                      completionHandler:hsAPICompletion];
    };
    
    [self.blizzardTokenAPI getAccessTokenAtRegion:regionHost
                                completionHandler:tokenAPICompletion];
}

@end
