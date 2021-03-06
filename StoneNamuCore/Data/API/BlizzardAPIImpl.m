//
//  BlizzardAPIImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <StoneNamuCore/BlizzardAPIImpl.h>
#import <StoneNamuCore/StoneNamuError.h>

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
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray<NSURLQueryItem *> new];
    
    if (options) {
        [options enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:key value:obj];
            [queryItems addObject:queryItem];
            [queryItem release];
        }];
    }
    
    NSURLQueryItem *tokenQueryItem = [[NSURLQueryItem alloc] initWithName:BlizzardHSAPIAccessToken value:accessToken];
    [queryItems addObject:tokenQueryItem];
    [tokenQueryItem release];
    
    components.queryItems = queryItems;
    [queryItems release];
    
    NSURL *url = components.URL;
    NSLog(@"%@", url.absoluteString);
    [components release];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ((response) && ([response isKindOfClass:[NSHTTPURLResponse class]])) {
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            
            if ((statusCode < 200) || (statusCode > 200)) {
                StoneNamuError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeServerError];
                completion(nil, response, error);
                return;
            }
        }
        
        completion(data, response, error);
    }];
    [task resume];
    [session finishTasksAndInvalidate];
}

@end
