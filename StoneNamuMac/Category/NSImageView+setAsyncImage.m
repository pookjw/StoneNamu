//
//  NSImageView+setAsyncImage.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/25/21.
//

#import "NSImageView+setAsyncImage.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "SpinnerView.h"

static NSString * const NSImageViewAsyncImageCategorySpinnerViewKey = @"NSImageViewAsyncImageCategorySpinnerViewKey";
static NSString * const NSImageViewAsyncImageCategoryDataCacheUseCaseKey = @"NSImageViewAsyncImageCategoryDataCacheUseCaseKey";
static NSString * const NSImageViewAsyncImageCategoryCurrentURLKey = @"NSImageViewAsyncImageCategoryCurrentURLKey";
static NSString * const NSImageViewAsyncImageCategorySessionTaskKey = @"NSImageViewAsyncImageCategorySessionTaskKey";

@interface NSImageView (setAsyncImage)
@property (nonatomic, retain) SpinnerView * _Nullable spinnerView;
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
    [self showSpinnerView];
    
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
                    [self removeSpinnerView];
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
                    [self showSpinnerView];
                } else {
                    [self removeSpinnerView];
                }
            }];
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
            NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        [self removeSpinnerView];
                        self.image = nil;
                    }];
                    completion(nil, error);
                } else if (data) {
                    [self.dataCacheUseCase makeDataCache:data identity:identity completion:^{
                        [self.dataCacheUseCase saveChanges];
                        
                        if ([self.currentURL isEqual:url]) {
                            NSImage *image = [[NSImage alloc] initWithData:data];
                            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                                [self removeSpinnerView];
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

- (void)showSpinnerView {
    if (self.spinnerView) {
        self.spinnerView.hidden = NO;
        [self.spinnerView startAnimating];
        return;
    }

    SpinnerView *spinnerView = [SpinnerView new];
    self.spinnerView = spinnerView;
    [self addSubview:spinnerView];
    spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:spinnerView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:0.3f
                                                                        constant:0.0f];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:spinnerView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:0.3f
                                                                        constant:0.0f];
    
    [NSLayoutConstraint activateConstraints:@[
        [spinnerView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [spinnerView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        widthConstraint,
        heightConstraint
    ]];
    
    [spinnerView startAnimating];
    [spinnerView release];
}

- (void)removeSpinnerView {
    if (self.spinnerView == nil) return;
    self.spinnerView.hidden = YES;
    [self.spinnerView stopAnimating];
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

    [CATransaction begin];
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.duration = 0.3f;
    fade.fromValue = [NSNumber numberWithFloat:0.0f];
    fade.toValue = [NSNumber numberWithFloat:1.0f];
    fade.removedOnCompletion = YES;
    [CATransaction setCompletionBlock:^{
        self.alphaValue = 1.0f;
    }];
    [self.layer addAnimation:fade forKey:@"fade"];
    [CATransaction commit];
}

//

- (SpinnerView * _Nullable)spinnerView {
    id progressIndicator = objc_getAssociatedObject(self, &NSImageViewAsyncImageCategorySpinnerViewKey);
    
    if (progressIndicator == NULL) {
        return nil;
    }
    
    return progressIndicator;
}

- (void)setSpinnerView:(SpinnerView *)spinnerView {
    objc_setAssociatedObject(self, &NSImageViewAsyncImageCategorySpinnerViewKey, spinnerView, OBJC_ASSOCIATION_RETAIN);
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
