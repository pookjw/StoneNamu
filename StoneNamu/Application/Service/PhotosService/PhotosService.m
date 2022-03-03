//
//  PhotosService.m
//  PhotosService
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "PhotosService.h"
#import "StoneNamuErrors.h"
#import <Photos/Photos.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <StoneNamuResources/StoneNamuResources.h>

@interface PhotosService () <UIActivityItemsConfigurationReading>
@property (copy) NSDictionary<NSString *, UIImage *> * _Nullable images;
@property (copy) NSDictionary<NSString *, NSURL *> * _Nullable urls;
@property (copy) NSDictionary<NSString *, NSURL *> * _Nullable localURLs;
@property (retain) PHPhotoLibrary *phPhotoLibrary;
@property (retain) id<HSCardUseCase> _Nullable hsCardUseCase;
@property (retain) id<DataCacheUseCase> _Nullable dataCacheUseCase;
@property (retain) NSOperationQueue *queue;
@end

@implementation PhotosService

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.images = nil;
        self.urls = nil;
        
        self.phPhotoLibrary = PHPhotoLibrary.sharedPhotoLibrary;
        self.hsCardUseCase = nil;
        self.dataCacheUseCase = nil;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
    }
    
    return self;
}

- (instancetype)initWithImages:(NSDictionary<NSString *,UIImage *> *)images {
    self = [self init];
    
    if (self) {
        self.images = images;
    }
    
    return self;
}

- (instancetype)initWithURLs:(NSDictionary<NSString *,NSURL *> *)urls {
    self = [self init];
    
    if (self) {
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        self.urls = urls;
    }
    
    return self;
}

- (instancetype)initWithHSCards:(NSSet<HSCard *> *)hsCards hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold {
    self = [self init];
    
    if (self) {
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
        NSMutableDictionary<NSString *, NSURL *> *urls = [NSMutableDictionary<NSString *, NSURL *> new];
        
        [hsCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, BOOL * _Nonnull stop) {
            urls[obj.name] = [hsCardUseCase recommendedImageURLOfHSCard:obj HSCardGameModeSlugType:hsCardGameModeSlugType isGold:isGold];
        }];
        
        self.urls = urls;
        [urls release];
        
        self.hsCardUseCase = hsCardUseCase;
        [hsCardUseCase release];
    }
    
    return self;
}

- (instancetype)initWithHSCards:(NSSet<HSCard *> *)hsCards hsGameModeSlugTypes:(NSDictionary<HSCard *, HSCardGameModeSlugType> *)hsCardGameModeSlugTypes isGolds:(NSDictionary<HSCard *, NSNumber *> *)isGolds {
    self = [self init];
    
    if (self) {
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
        NSMutableDictionary<NSString *, NSURL *> *urls = [NSMutableDictionary<NSString *, NSURL *> new];
        
        [hsCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, BOOL * _Nonnull stop) {
            urls[obj.name] = [hsCardUseCase recommendedImageURLOfHSCard:obj HSCardGameModeSlugType:hsCardGameModeSlugTypes[obj] isGold:isGolds[obj].boolValue];
        }];
        
        self.urls = urls;
        [urls release];
        
        self.hsCardUseCase = hsCardUseCase;
        [hsCardUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_images release];
    [_urls release];
    [_localURLs release];
    [_phPhotoLibrary release];
    [_hsCardUseCase release];
    [_dataCacheUseCase release];
    [_queue release];
    [super dealloc];
}

- (void)beginSavingFromViewController:(UIViewController *)viewController completion:(PhotosServiceCompletion)completion {
    [self.queue addBarrierBlock:^{
        if (self.images != nil) {
            [self saveImages:self.images.allValues fromViewController:viewController completionHandler:completion];
        } else if (self.urls != nil) {
            [self imagesFromURLs:self.urls completion:^(NSDictionary<NSString *,UIImage *> * _Nullable images, NSError * _Nullable error) {
                self.images = images;
                [self saveImages:images.allValues fromViewController:viewController completionHandler:completion];
            }];
        } else {
            completion(NO, nil);
        }
    }];
}

- (void)beginSharingFromViewController:(UIViewController *)viewController completion:(nonnull PhotosServiceCompletion)completion {
    [self.queue addBarrierBlock:^{
        if (self.images != nil) {
            [self shareImages:self.images fromViewController:viewController completion:completion];
        } else if (self.urls != nil) {
            [self imagesFromURLs:self.urls completion:^(NSDictionary<NSString *,UIImage *> * _Nullable images, NSError * _Nullable error) {
                self.images = images;
                [self shareImages:images fromViewController:viewController completion:completion];
            }];
        }
    }];
}

- (void)saveImages:(NSArray<UIImage *> *)images fromViewController:(UIViewController *)viewController completionHandler:(PhotosServiceCompletion)completionHandler {
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelAddOnly handler:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                    [self.phPhotoLibrary performChanges:^{
                        [PHAssetChangeRequest creationRequestForAssetFromImage:obj];
                    }
                                      completionHandler:^(BOOL success, NSError * _Nullable error) {
                        if ((!success) || (error != nil)) {
                            completionHandler(success, error);
                            *stop = YES;
                            return;
                        }
                        
                        if (idx == (images.count - 1)) {
                            completionHandler(YES, nil);
                            return;
                        }
                    }];
                    break;
                default:
                    [self askPopupAndOpenAppSettingsFromViewController:viewController];
                    break;
            }
        }];
    }];
}

- (void)askPopupAndOpenAppSettingsFromViewController:(UIViewController *)viewController {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[ResourcesService localizationForKey:LocalizableKeyNeedPhotoPermission]
                                                                       message:[ResourcesService localizationForKey:LocalizableKeyPleaseAllowPhotoPermission]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyDismiss]
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            [self openAppSettingsFromScene:viewController.view.window.windowScene];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:confirmAction];
        
        [viewController presentViewController:alert animated:YES completion:^{}];
    }];
}

- (void)openAppSettingsFromScene:(UIScene *)scene {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (url) {
        if (scene) {
            [scene openURL:url options:nil completionHandler:^(BOOL success) {}];
        } else {
            [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {}];
        }
    }
}

- (void)shareImages:(NSDictionary<NSString *, UIImage *> *)images fromViewController:(UIViewController *)viewController completion:(PhotosServiceCompletion)completion {
    NSURL *tmpURL = NSFileManager.defaultManager.temporaryDirectory;
    NSMutableDictionary<NSString *, NSURL *> *localURLs = [NSMutableDictionary<NSString *, NSURL *> new];
    
    [images enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UIImage * _Nonnull obj, BOOL * _Nonnull stop) {
        NSURL *targetURL = [[tmpURL URLByAppendingPathComponent:key] URLByAppendingPathExtension:UTTypePNG.preferredFilenameExtension];
        NSData *data = UIImagePNGRepresentation(obj);
        [data writeToURL:targetURL atomically:YES];
        localURLs[key] = targetURL;
    }];
    
    self.localURLs = localURLs;
    [localURLs release];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItemsConfiguration:self];
        vc.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
            completion(completed, activityError);
        };
        [viewController presentViewController:vc animated:YES completion:^{}];
        [vc release];
    }];
}

- (void)imagesFromURLs:(NSDictionary<NSString *, NSURL *> *)urls completion:(void (^)(NSDictionary<NSString *, UIImage *> * _Nullable images, NSError * _Nullable error))completion {
    [self.queue addBarrierBlock:^{
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:-((NSInteger)self.urls.count) + 1];
        NSMutableDictionary<NSString *, NSData *> *results = [NSMutableDictionary<NSString *, NSData *> new];
        NSError * __block _Nullable writeError = nil;
        
        [urls enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSURL * _Nonnull obj, BOOL * _Nonnull stop) {
            if (writeError != nil) {
                *stop = YES;
                [semaphore signal];
                return;
            }
            
            [self.dataCacheUseCase dataCachesWithIdentity:obj.absoluteString completion:^(NSArray<NSData *> * _Nullable datas, NSError * _Nullable error) {
                if (writeError != nil) {
                    [semaphore signal];
                    return;
                }
                
                NSData * _Nullable data = datas.firstObject;
                
                if (data == nil) {
                    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
                    
                    NSURLSessionTask *sessionTask = [session dataTaskWithURL:obj completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        if (writeError != nil) {
                            [semaphore signal];
                            return;
                        }
                        
                        if (error != nil) {
                            writeError = [error copy];
                            [semaphore signal];
                            return;
                        }
                        
                        [self.dataCacheUseCase makeDataCache:data identity:obj.absoluteString completion:^{
                            if (writeError != nil) {
                                [semaphore signal];
                                return;
                            }
                            
                            results[key] = data;
                            [semaphore signal];
                        }];
                    }];
                    
                    [sessionTask resume];
                    [session finishTasksAndInvalidate];
                } else {
                    results[key] = data;
                    [semaphore signal];
                }
            }];
        }];
        
        [semaphore wait];
        [semaphore release];
        
        //
        
        NSMutableDictionary<NSString *, UIImage *> *images = [NSMutableDictionary<NSString *, UIImage *> new];
        
        [results enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSData * _Nonnull obj, BOOL * _Nonnull stop) {
            UIImage *image = [[UIImage alloc] initWithData:obj];
            images[key] = image;
            [image release];
        }];
        
        [results release];
        
        //
        
        if (writeError != nil) {
            [images release];
            completion(nil, [writeError autorelease]);
            return;
        } else {
            completion([images autorelease], nil);
            return;
        }
    }];
}

#pragma mark - UIActivityItemsConfigurationReading

- (NSArray<NSItemProvider *> *)itemProvidersForActivityItemsConfiguration {
    NSMutableArray<NSItemProvider *> *itemProvicers = [NSMutableArray<NSItemProvider *> new];
    
    [self.localURLs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSURL * _Nonnull obj, BOOL * _Nonnull stop) {
        NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithContentsOfURL:obj];
        [itemProvicers addObject:itemProvider];
        [itemProvider release];
    }];
    
    return [itemProvicers autorelease];
}

@end
