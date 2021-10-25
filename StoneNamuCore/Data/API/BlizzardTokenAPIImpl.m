//
//  BlizzardTokenAPIImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import "BlizzardTokenAPIImpl.h"

static NSString * const BlizzardTokenAPIBasePath = @"/oauth/token";
static NSString * const BlizzardTokenAPIGrantTypeKey = @"grant_type";
static NSString * const BlizzardTokenAPIGrantTypeValue = @"client_credentials";
static NSString * const BlizzardTokenAPIAuthorizationKey = @"Authorization";
static NSString * const BlizzardTokenAPIAuthorizationValue = @"Basic NDBjMjRlNDhkY2E5NGEwNjgzY2FjNTFmNDk5NWZkZjE6Z1N4NnladkRQUGx3MFZyUXYxVmpESFRmYUVhclYyRmY=";

@implementation BlizzardTokenAPIImpl

- (void)getAccessTokenAtRegion:(BlizzardAPIRegionHost)regionHost
             completionHandler:(BlizzardTokenAPICompletionType)completion {
    NSURLComponents *components = [NSURLComponents new];
    
    components.scheme = @"https";
    components.host = NSStringForOAuthFromRegionHost(regionHost);
    components.path = BlizzardTokenAPIBasePath;
    components.queryItems = @[
        [[[NSURLQueryItem alloc] initWithName:BlizzardTokenAPIGrantTypeKey value:BlizzardTokenAPIGrantTypeValue] autorelease]
    ];
    
    NSURL *url = components.URL;
    [components release];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.allHTTPHeaderFields = @{
        BlizzardTokenAPIAuthorizationKey: BlizzardTokenAPIAuthorizationValue
    };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:completion];
    [request release];
    [task resume];
}

@end
