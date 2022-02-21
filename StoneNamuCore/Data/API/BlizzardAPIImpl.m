//
//  BlizzardAPIImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <StoneNamuCore/BlizzardAPIImpl.h>

static NSString * const BlizzardHSAPIAccessToken = @"access_token";

@implementation BlizzardAPIImpl

- (void)getAtRegion:(BlizzardAPIRegionHost)regionHost
               path:(NSString *)path
        accessToken:(NSString *)accessToken
            options:(NSDictionary<NSString *, id> * _Nullable)options
  completionHandler:(BlizzardAPICompletion)completion
{
    NSURLComponents *components = [NSURLComponents new];
    
    components.scheme = @"https";
    components.host = NSStringForAPIFromRegionHost(regionHost);
    components.path = path;
    
    if (options) {
        NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray<NSURLQueryItem *> new];
        
        [options enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:key value:obj];
            [queryItems addObject:queryItem];
            [queryItem release];
        }];
        
        [queryItems addObject:[[[NSURLQueryItem alloc] initWithName:BlizzardHSAPIAccessToken value:accessToken] autorelease]];
        
        components.queryItems = queryItems;
        [queryItems release];
    }
    
    NSURL *url = components.URL;
    NSLog(@"%@", url.absoluteString);
    [components release];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:completion];
    [task resume];
}

@end
