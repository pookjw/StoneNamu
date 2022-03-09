//
//  ImageViewAsyncService.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/9/22.
//

#import "ImageViewAsyncService.h"
#import <objc/runtime.h>
#import <StoneNamuCore/StoneNamuCore.h>

static NSString * const ImageViewAsyncServiceActivityIndicatorViewKey = @"ImageViewAsyncServiceActivityIndicatorViewKey";
static NSString * const ImageViewAsyncServiceCurrentURLKey = @"ImageViewAsyncServiceCurrentURLKey";
static NSString * const ImageViewAsyncServiceSessionTaskKey = @"ImageViewAsyncServiceSessionTaskKey";

@interface ImageViewAsyncService ()
@property (nonatomic, retain) id<DataCacheUseCase> dataCacheUseCase;
@end

@implementation ImageViewAsyncService

- (instancetype)init {
    self = [super init];
    
    if (self) {
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_dataCacheUseCase release];
    [super dealloc];
}

- (void)setAsyncImageToImageView:(id)imageView withURL:(NSURL * _Nullable)url indicator:(BOOL)indicator {
    [self setAsyncImageToImageView:imageView withURL:url indicator:indicator completion:^(UIImage * _Nullable image, NSError * _Nullable error) {}];
}

- (void)setAsyncImageToImageView:(id)imageView withURL:(NSURL * _Nullable)url indicator:(BOOL)indicator completion:(ImageViewAsyncServiceCompletion)completion {
    NSURL * _Nullable currentURL = [self currentURLFromImageView:imageView];
    
    if ([url isEqual:currentURL]) {
        completion([imageView image], nil);
        return;
    }
    
    [[self sessionTaskFromImageView:imageView] cancel];
    
    [imageView setImage:nil];
    [self setCurrentURL:url toImageView:imageView];
    
    if (url == nil) {
        completion(nil, nil);
        return;
    }
    
    NSString *identity = url.absoluteString;
    
    if (indicator) {
        [self showActivityIndicatorViewOnImageView:imageView];
    } else {
        [self removeActivityIndicatorViewFromImageView:imageView];
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
            if ([[self currentURLFromImageView:imageView] isEqual:url]) {
                UIImage *image = [UIImage imageWithData:cachedData];
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    [self removeActivityIndicatorViewFromImageView:imageView];
                    [self loadImageWithFade:image toImageView:imageView];
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
                        [self removeActivityIndicatorViewFromImageView:imageView];
                        [imageView setImage:nil];
                    }];
                    NSLog(@"%@", error.localizedDescription);
                    completion(nil, error);
                } else if (data) {
                    [self.dataCacheUseCase makeDataCache:data identity:url.absoluteString completion:^{
                        if ([[self currentURLFromImageView:imageView] isEqual:url]) {
                            UIImage *image = [UIImage imageWithData:data];
                            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                                [self removeActivityIndicatorViewFromImageView:imageView];
                                [self loadImageWithFade:image toImageView:imageView];
                                completion(image, nil);
                            }];
                        }
                    }];
                }
            }];
            [sessionTask resume];
            [session finishTasksAndInvalidate];
            [self setSessionTask:sessionTask toImageView:imageView];
        }
    }];
}

- (void)cancelAsyncImageOnImageView:(id)imageView {
    [[self sessionTaskFromImageView:imageView] cancel];
}

- (void)clearSetAsyncImageContextsOnImageView:(id)imageView; {
    [self cancelAsyncImageOnImageView:imageView];
    
    [[self activityIndicatorViewFromImageView:imageView] removeFromSuperview];
    [self setActivityIndicatorView:nil toImageView:imageView];
    
    [self setCurrentURL:nil toImageView:imageView];
}

- (void)loadImageWithFade:(UIImage *)image toImageView:(id)imageView {
    [imageView setImage:image];
    
    [NSClassFromString(@"CATransaction") begin];
    
    id fade = [NSClassFromString(@"CABasicAnimation") animationWithKeyPath:@"opacity"];
    [fade setDuration:0.3f];
    [fade setFromValue:[NSNumber numberWithFloat:0.0f]];
    [fade setToValue:[NSNumber numberWithFloat:1.0f]];
    [fade setRemovedOnCompletion:YES];
    
    [[imageView layer] addAnimation:fade forKey:@"fade"];
    
    [NSClassFromString(@"CATransaction") commit];
}

- (void)showActivityIndicatorViewOnImageView:(id)imageView {
    id _Nullable aiv = [self activityIndicatorViewFromImageView:imageView];
    
    if (aiv) {
        [aiv setHidden:NO];
        [aiv setAnimating:YES skipBeginOrEndAnimations:YES];
        return;
    }
    
    id activityIndicatorView = [NSClassFromString(@"PUICActivityIndicatorView") new];
    [imageView addSubview:activityIndicatorView];
    [activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSClassFromString(@"NSLayoutConstraint") activateConstraints:@[
        [[activityIndicatorView centerXAnchor] constraintEqualToAnchor:[imageView centerXAnchor]],
        [[activityIndicatorView centerYAnchor] constraintEqualToAnchor:[imageView centerYAnchor]],
    ]];
    
    [activityIndicatorView setAnimating:YES skipBeginOrEndAnimations:YES];
    [self setActivityIndicatorView:activityIndicatorView toImageView:imageView];
    [activityIndicatorView release];
}

- (void)removeActivityIndicatorViewFromImageView:(id)imageView {
    id _Nullable activityIndicatorView = [self activityIndicatorViewFromImageView:imageView];
    if (activityIndicatorView == nil) return;
    
    [activityIndicatorView setHidden:YES];
    [activityIndicatorView setAnimating:NO skipBeginOrEndAnimations:YES];
}

//

- (id)activityIndicatorViewFromImageView:(id)imageView {
    id activityIndicatorView = objc_getAssociatedObject(imageView, &ImageViewAsyncServiceActivityIndicatorViewKey);
    
    if (activityIndicatorView == NULL) {
        return nil;
    }
    
    return activityIndicatorView;
}

- (void)setActivityIndicatorView:(id)activityIndicatorView toImageView:(id)imageView {
    objc_setAssociatedObject(imageView, &ImageViewAsyncServiceActivityIndicatorViewKey, activityIndicatorView, OBJC_ASSOCIATION_RETAIN);
}

- (NSURL * _Nullable)currentURLFromImageView:(id)imageView {
    id currentURL = objc_getAssociatedObject(imageView, &ImageViewAsyncServiceCurrentURLKey);
    
    if (currentURL == NULL) {
        return nil;
    }
    
    return currentURL;
}

- (void)setCurrentURL:(NSURL *)currentURL toImageView:(id)imageView {
    objc_setAssociatedObject(imageView, &ImageViewAsyncServiceCurrentURLKey, currentURL, OBJC_ASSOCIATION_RETAIN);
}

- (NSURLSessionTask *)sessionTaskFromImageView:(id)imageView {
    id sessionTask = objc_getAssociatedObject(imageView, &ImageViewAsyncServiceSessionTaskKey);
    
    if (sessionTask == NULL) {
        return nil;
    }
    
    return sessionTask;
}

- (void)setSessionTask:(NSURLSessionTask *)sessionTask toImageView:(id)imageView {
    objc_setAssociatedObject(imageView, &ImageViewAsyncServiceSessionTaskKey, sessionTask, OBJC_ASSOCIATION_RETAIN);
}

@end
