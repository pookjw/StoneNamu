//
//  BlizzardHSAPIImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "BlizzardHSAPIImpl.h"

static NSString * const BlizzardHSAPIBasePath = @"/hearthstone/cards";
static NSString * const BlizzardHSAPIAccessToken = @"access_token";

@implementation BlizzardHSAPIImpl

- (void)fetchCardsAtRegion:(BlizzardAPIRegionHost)regionHost
               accessToken:(NSString *)accessToken
                   options:(NSDictionary<NSString *, id> *)options
         completionHandler:(BlizzardHSAPICompletionType)completion
{
    NSURLComponents *components = [NSURLComponents new];
    
    components.scheme = @"https";
    components.host = NSStringForAPIFromRegionHost(regionHost);
    components.path = BlizzardHSAPIBasePath;
    
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

- (void)fetchCardAtRegion:(BlizzardAPIRegionHost)regionHost
              accessToken:(NSString *)accessToken
                 cardSlug:(NSString *)cardSlug
                  options:(NSDictionary<NSString *, id> *)options
        completionHandler:(BlizzardHSAPICompletionType)completion
{
    NSURLComponents *components = [NSURLComponents new];
    
    components.scheme = @"https";
    components.host = NSStringForAPIFromRegionHost(regionHost);
    components.path = [NSString stringWithFormat:@"%@/%@", BlizzardHSAPIBasePath, cardSlug];
    
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
    [url release];
    [task resume];
    [session finishTasksAndInvalidate];
}

@end
