//
//  UIImageView+setAsyncImage.m
//  UIImageView+setAsyncImage
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "UIImageView+setAsyncImage.h"
#import <objc/runtime.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "SpinnerView.h"

static NSString * const UIImageViewAsyncImageCategorySpinnerViewKey = @"UIImageViewAsyncImageCategorySpinnerViewKey";
static NSString * const UIImageViewAsyncImageCategoryDataCacheUseCaseKey = @"UIImageViewAsyncImageCategoryDataCacheUseCaseKey";
static NSString * const UIImageViewAsyncImageCategoryCurrentURLKey = @"UIImageViewAsyncImageCategoryCurrentURLKey";
static NSString * const UIImageViewAsyncImageCategorySessionTaskKey = @"UIImageViewAsyncImageCategorySessionTaskKey";

@interface UIImageView (setAsyncImage)
@property (nonatomic, retain) SpinnerView * _Nullable spinnerView;
@property (nonatomic, retain) id<DataCacheUseCase> _Nullable dataCacheUseCase;
@property (nonatomic, retain) NSURL * _Nullable currentURL;
@property (nonatomic, retain) NSURLSessionTask * _Nullable sessionTask;
@end

@implementation UIImageView (setAsyncImage)

- (void)setAsyncImageWithURL:(NSURL * _Nullable)url indicator:(BOOL)indicator {
    [self setAsyncImageWithURL:url indicator:indicator completion:^(UIImage * _Nullable image, NSError * _Nullable error) {}];
}

- (void)setAsyncImageWithURL:(NSURL *)url indicator:(BOOL)indicator completion:(UIImageViewSetAsyncImageCompletion)completion {
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
    
    if (indicator) {
        [self showSpinnerView];
    } else {
        [self removeSpinnerView];
    }
    
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
                UIImage *image = [UIImage imageWithData:cachedData];
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    [self removeSpinnerView];
                    [self loadImageWithFade:image];
                    completion(image, nil);
                }];
                return;
            } else {
                return;
            }
        } else {
            // if not found, download from server
            NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
            NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        [self removeSpinnerView];
                        self.image = nil;
                    }];
                    completion(nil, error);
                } else if (data) {
                    [self.dataCacheUseCase makeDataCache:data identity:url.absoluteString completion:^{
                        [self.dataCacheUseCase saveChanges];
                        
                        if ([self.currentURL isEqual:url]) {
                            UIImage *image = [UIImage imageWithData:data];
                            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                                [self removeSpinnerView];
                                [self loadImageWithFade:image];
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

- (void)cancelAsyncImage {
    [self.sessionTask cancel];
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

- (void)loadImageWithFade:(UIImage *)image {
    self.image = image;
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

//

- (SpinnerView * _Nullable)spinnerView {
    id spinnerView = objc_getAssociatedObject(self, &UIImageViewAsyncImageCategorySpinnerViewKey);
    
    if (spinnerView == NULL) {
        return nil;
    }
    
    return spinnerView;
}

- (void)setSpinnerView:(SpinnerView *)spinnerView {
    objc_setAssociatedObject(self, &UIImageViewAsyncImageCategorySpinnerViewKey, spinnerView, OBJC_ASSOCIATION_RETAIN);
}

- (id<DataCacheUseCase>)dataCacheUseCase {
    id dataCacheUseCase = objc_getAssociatedObject(self, &UIImageViewAsyncImageCategoryDataCacheUseCaseKey);
    
    if (dataCacheUseCase == NULL) {
        return nil;
    }
    
    return dataCacheUseCase;
}

- (void)setDataCacheUseCase:(id<DataCacheUseCase> _Nullable)dataCacheUseCase {
    objc_setAssociatedObject(self, &UIImageViewAsyncImageCategoryDataCacheUseCaseKey, dataCacheUseCase, OBJC_ASSOCIATION_RETAIN);
}

- (NSURL * _Nullable)currentURL {
    id currentURL = objc_getAssociatedObject(self, &UIImageViewAsyncImageCategoryCurrentURLKey);
    
    if (currentURL == NULL) {
        return nil;
    }
    
    return currentURL;
}

- (void)setCurrentURL:(NSURL *)currentURL {
    objc_setAssociatedObject(self, &UIImageViewAsyncImageCategoryCurrentURLKey, currentURL, OBJC_ASSOCIATION_RETAIN);
}

- (NSURLSessionTask *)sessionTask {
    id sessionTask = objc_getAssociatedObject(self, &UIImageViewAsyncImageCategorySessionTaskKey);
    
    if (sessionTask == NULL) {
        return nil;
    }
    
    return sessionTask;
}

- (void)setSessionTask:(NSURLSessionTask *)sessionTask {
    objc_setAssociatedObject(self, &UIImageViewAsyncImageCategorySessionTaskKey, sessionTask, OBJC_ASSOCIATION_RETAIN);
}

@end
