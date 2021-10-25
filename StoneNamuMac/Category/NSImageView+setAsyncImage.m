//
//  NSImageView+setAsyncImage.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/25/21.
//

#import "NSImageView+setAsyncImage.h"
#import <objc/runtime.h>
#import <QuartzCore/CoreAnimation.h>
#import <StoneNamuCore/StoneNamuCore.h>

static NSString * const NSImageViewAsyncImageCategoryProgressIndicatorKey = @"NSImageViewAsyncImageCategoryProgressIndicatorKey";
static NSString * const NSImageViewAsyncImageCategoryDataCacheUseCaseKey = @"NSImageViewAsyncImageCategoryDataCacheUseCaseKey";
static NSString * const NSImageViewAsyncImageCategoryCurrentURLKey = @"NSImageViewAsyncImageCategoryCurrentURLKey";
static NSString * const NSImageViewAsyncImageCategorySessionTaskKey = @"NSImageViewAsyncImageCategorySessionTaskKey";

@interface NSImageView (setAsyncImage)
@property (nonatomic, retain) NSProgressIndicator * _Nullable progressIndicator;
@property (nonatomic, retain) id<DataCacheUseCase> _Nullable dataCacheUseCase;
@property (nonatomic, retain) NSURL * _Nullable currentURL;
@property (nonatomic, retain) NSURLSessionTask * _Nullable sessionTask;
@end

@implementation NSImageView (setAsyncImage)

- (void)setAsyncImageWithURL:(NSURL *)url indicator:(BOOL)indicator {
    [self setAsyncImageWithURL:url indicator:indicator completion:^(NSImage * _Nullable image, NSError * _Nullable error) {}];
}

- (void)setAsyncImageWithURL:(NSURL *)url indicator:(BOOL)indicator completion:(NSImageViewSetAsyncImageCompletion)completion {
    if ([url isEqual:self.currentURL]) {
        completion(self.image, nil);
        return;
    }
    
    [self.sessionTask cancel];
    [self configureDataCacheUseCase];
    
    self.image = nil;
    self.currentURL = url;
    
    if (url == nil) {
        completion(nil, nil);
        return;
    }
    
    NSString *identity = url.absoluteString;
    
    // Fetch Cahce Data from another background thread...
    [self.dataCacheUseCase dataCachesWithIdentity:identity completion:^(NSArray<NSData *> * _Nonnull cachedDatas, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        
        NSData * _Nullable cachedData = cachedDatas.lastObject;
        
        if (cachedData) {
            // if cached data was found...
            if ([self.currentURL isEqual:url]) {
                NSImage *image = [[NSImage alloc] initWithData:cachedData];
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    [self removeProgressIndicator];
                    [self loadImageWithFade:image];
                    [image autorelease];
                    completion(image, nil);
                }];
                return;
            } else {
                return;
            }
        } else {
            // if not found, download from server
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                if (indicator) {
                    [self showProgressIndicator];
                } else {
                    [self removeProgressIndicator];
                }
            }];
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
            NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        [self removeProgressIndicator];
                        self.image = nil;
                    }];
                    completion(nil, error);
                } else if (data) {
                    [self.dataCacheUseCase makeDataCache:data identity:identity completion:^{
                        [self.dataCacheUseCase saveChanges];
                        
                        if ([self.currentURL isEqual:url]) {
                            NSImage *image = [[NSImage alloc] initWithData:data];
                            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                                [self removeProgressIndicator];
                                [self loadImageWithFade:image];
                                [image autorelease];
                                completion(image, nil);
                            }];
                        }
                    }];
                }
            }];
            [sessionTask resume];
            self.sessionTask = sessionTask;
        }
    }];
}

- (void)showProgressIndicator {
//    if (self.progressIndicator) {
//        self.progressIndicator.hidden = NO;
//        [self.progressIndicator startAnimation:nil];
//        return;
//    }
//
//    NSProgressIndicator *progressIndicator = [NSProgressIndicator new];
//    self.progressIndicator = progressIndicator;
//    [self addSubview:progressIndicator];
//    progressIndicator.translatesAutoresizingMaskIntoConstraints = NO;
//    [NSLayoutConstraint activateConstraints:@[
//        [progressIndicator.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
//        [progressIndicator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
//    ]];
//    progressIndicator.controlTint = NSBlueControlTint;
//    [progressIndicator startAnimation:nil];
//    [progressIndicator release];
}

- (void)removeProgressIndicator {
//    if (self.progressIndicator == nil) return;
//    self.progressIndicator.hidden = YES;
//    [self.progressIndicator stopAnimation:nil];
}

- (void)configureDataCacheUseCase {
    if (self.dataCacheUseCase == nil) {
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
    }
}

- (void)loadImageWithFade:(NSImage *)image {
    self.image = image;
    self.wantsLayer = YES;
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.duration = 0.3f;
    fade.fromValue = [NSNumber numberWithFloat:0.0f];
    fade.toValue = [NSNumber numberWithFloat:1.0f];
    fade.removedOnCompletion = YES;
    [CATransaction setCompletionBlock:^{
        self.alphaValue = 1.0;
    }];
    [self.layer addAnimation:fade forKey:@"fade"];
    [CATransaction commit];
}

//

- (NSProgressIndicator * _Nullable)progressIndicator {
    id progressIndicator = objc_getAssociatedObject(self, &NSImageViewAsyncImageCategoryProgressIndicatorKey);
    
    if (progressIndicator == NULL) {
        return nil;
    }
    
    return progressIndicator;
}

- (void)setProgressIndicator:(NSProgressIndicator *)activityIndicator {
    objc_setAssociatedObject(self, &NSImageViewAsyncImageCategoryProgressIndicatorKey, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (id<DataCacheUseCase>)dataCacheUseCase {
    id dataCacheUseCase = objc_getAssociatedObject(self, &NSImageViewAsyncImageCategoryDataCacheUseCaseKey);
    
    if (dataCacheUseCase == NULL) {
        return nil;
    }
    
    return dataCacheUseCase;
}

- (void)setDataCacheUseCase:(id<DataCacheUseCase> _Nullable)dataCacheUseCase {
    objc_setAssociatedObject(self, &NSImageViewAsyncImageCategoryDataCacheUseCaseKey, dataCacheUseCase, OBJC_ASSOCIATION_RETAIN);
}

- (NSURL * _Nullable)currentURL {
    id currentURL = objc_getAssociatedObject(self, &NSImageViewAsyncImageCategoryCurrentURLKey);
    
    if (currentURL == NULL) {
        return nil;
    }
    
    return currentURL;
}

- (void)setCurrentURL:(NSURL *)currentURL {
    objc_setAssociatedObject(self, &NSImageViewAsyncImageCategoryCurrentURLKey, currentURL, OBJC_ASSOCIATION_RETAIN);
}

- (NSURLSessionTask *)sessionTask {
    id sessionTask = objc_getAssociatedObject(self, &NSImageViewAsyncImageCategorySessionTaskKey);
    
    if (sessionTask == NULL) {
        return nil;
    }
    
    return sessionTask;
}

- (void)setSessionTask:(NSURLSessionTask *)sessionTask {
    objc_setAssociatedObject(self, &NSImageViewAsyncImageCategorySessionTaskKey, sessionTask, OBJC_ASSOCIATION_RETAIN);
}

@end
