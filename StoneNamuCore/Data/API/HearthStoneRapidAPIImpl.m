//
//  HearthStoneRapidAPIImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 3/4/22.
//

#import <StoneNamuCore/HearthStoneRapidAPIImpl.h>
#import <StoneNamuCore/StoneNamuError.h>

@implementation HearthStoneRapidAPIImpl

- (void)getWithPath:(nonnull NSString *)path completionHandler:(nonnull HearthStoneRapidAPICompletion)completion {
    NSURLComponents *components = [NSURLComponents new];
    
    components.scheme = @"https";
    components.host = @"omgvamp-hearthstone-v1.p.rapidapi.com";
    components.path = path;
    
    NSURL *url = components.URL;
    NSLog(@"%@", url.absoluteString);
    [components release];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    request.allHTTPHeaderFields = @{@"x-rapidapi-key": @"67a008d3f9msh3351233e47c1b5bp159b64jsn09e0f31543cf"};
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
