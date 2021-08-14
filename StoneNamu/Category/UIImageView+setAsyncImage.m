//
//  UIImageView+setAsyncImage.m
//  UIImageView+setAsyncImage
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "UIImageView+setAsyncImage.h"
#import <objc/runtime.h>
#import "DataCacheUseCaseImpl.h"

static NSString * const UIImageViewAsyncImageCategoryActivityIndicatorKey = @"UIImageViewAsyncImageCategoryActivityIndicatorKey";
static NSString * const UIImageViewAsyncImageCategoryDataCacheUseCaseKey = @"UIImageViewAsyncImageCategoryDataCacheUseCaseKey";
static NSString * const UIImageViewAsyncImageCategoryCurrentURLKey = @"UIImageViewAsyncImageCategoryCurrentURLKey";
static NSString * const UIImageViewAsyncImageCategorySessionTaskKey = @"UIImageViewAsyncImageCategorySessionTaskKey";

@interface UIImageView (setAsyncImage)
@property (nonatomic, assign) UIActivityIndicatorView * _Nullable activityIndicator;
@property (nonatomic, assign) id<DataCacheUseCase> _Nullable dataCacheUseCase;
@property (nonatomic, assign) NSURL * _Nullable currentURL;
@property (nonatomic, assign) NSURLSessionTask * _Nullable sessionTask;
@end

@implementation UIImageView (setAsyncImage)

- (void)dealloc {
    objc_removeAssociatedObjects(self);
    [super dealloc];
}

- (void)setAsyncImageWithURL:(NSURL * _Nullable)url indicator:(BOOL)indicator {
    if ([url isEqual:self.currentURL]) {
        return;
    }
    
    [self.sessionTask cancel];
    [self configureDataCacheUseCase];
    
    self.image = nil;
    self.currentURL = url;
    
    NSString *identity = url.absoluteString;
    
    // Fetch Cahce Data from another background thread...
    [self.dataCacheUseCase dataCachesWithIdentity:identity completion:^(NSArray<NSData *> * _Nonnull cachedDatas, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        NSData * _Nullable cachedData = cachedDatas.lastObject;
        
        if (cachedData) {
            // if cached data was found...
            if ([self.currentURL isEqual:url]) {
                UIImage *image = [UIImage imageWithData:cachedData];
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    [self removeActivityIndicator];
                    [self loadImageWithFade:image];
                }];
            }
        } else {
            // if not found, download from server
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                if (indicator) {
                    [self showActivityIndicator];
                } else {
                    [self removeActivityIndicator];
                }
            }];
            
            NSURLSession *sharedSession = NSURLSession.sharedSession;
            NSURLSessionTask *sessionTask = [sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        [self removeActivityIndicator];
                        self.image = nil;
                    }];
                } else if (data) {
                    [self.dataCacheUseCase createDataCache:data identity:url.absoluteString];
                    
                    if ([self.currentURL isEqual:url]) {
                        UIImage *image = [UIImage imageWithData:data];
                        [NSOperationQueue.mainQueue addOperationWithBlock:^{
                            [self removeActivityIndicator];
                            [self loadImageWithFade:image];
                        }];
                    }
                }
            }];
            [sessionTask resume];
            [sharedSession finishTasksAndInvalidate];
            self.sessionTask = sessionTask;
        }
    }];
}

- (void)showActivityIndicator {
    if (self.activityIndicator) {
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        return;
    }
    
    UIActivityIndicatorView *activityIndicator = [UIActivityIndicatorView new];
    self.activityIndicator = activityIndicator;
    [self addSubview:activityIndicator];
    activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [activityIndicator.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [activityIndicator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];
    [activityIndicator startAnimating];
    [activityIndicator release];
}

- (void)removeActivityIndicator {
    if (self.activityIndicator == nil) return;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
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

- (UIActivityIndicatorView * _Nullable)activityIndicator {
    return objc_getAssociatedObject(self, &UIImageViewAsyncImageCategoryActivityIndicatorKey);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &UIImageViewAsyncImageCategoryActivityIndicatorKey, activityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<DataCacheUseCase>)dataCacheUseCase {
    return objc_getAssociatedObject(self, &UIImageViewAsyncImageCategoryDataCacheUseCaseKey);
}

- (void)setDataCacheUseCase:(id<DataCacheUseCase> _Nullable)dataCacheUseCase {
    objc_setAssociatedObject(self, &UIImageViewAsyncImageCategoryDataCacheUseCaseKey, dataCacheUseCase, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURL * _Nullable)currentURL {
    return objc_getAssociatedObject(self, &UIImageViewAsyncImageCategoryCurrentURLKey);
}

- (void)setCurrentURL:(NSURL *)currentURL {
    objc_setAssociatedObject(self, &UIImageViewAsyncImageCategoryCurrentURLKey, currentURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURLSessionTask *)sessionTask {
    return objc_getAssociatedObject(self, &UIImageViewAsyncImageCategorySessionTaskKey);
}

- (void)setSessionTask:(NSURLSessionTask *)sessionTask {
    objc_setAssociatedObject(self, &UIImageViewAsyncImageCategorySessionTaskKey, sessionTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
