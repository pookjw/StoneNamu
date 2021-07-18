//
//  BlizzardHSAPIImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "BlizzardHSAPIImpl.h"

static NSString * const BlizzardHSAPIAccessToken = @"access_token";

@implementation BlizzardHSAPIImpl

- (void)getAtRegion:(BlizzardAPIRegionHost)regionHost
               path:(NSString *)path
        accessToken:(NSString *)accessToken
            options:(NSDictionary<NSString *, id> *)options
  completionHandler:(BlizzardHSAPICompletion)completion
{
    NSURLComponents *components = [NSURLComponents new];
    
    components.scheme = @"https";
    components.host = NSStringForAPIFromRegionHost(regionHost);
    components.path = path;
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [@[] mutableCopy];
    
    [options enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [queryItems addObject:[[[NSURLQueryItem alloc] initWithName:key value:obj] autorelease]];
    }];
    
    [queryItems addObject:[[[NSURLQueryItem alloc] initWithName:BlizzardHSAPIAccessToken value:accessToken] autorelease]];
    
    components.queryItems = queryItems;
    [queryItems release];
    
    NSURL *url = components.URL;
    [components release];
    
    NSURLSession *session = NSURLSession.sharedSession;
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:completion];
    [task resume];
    [session finishTasksAndInvalidate];
}

@end
