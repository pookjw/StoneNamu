//
//  PhotosService.m
//  PhotosService
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "PhotosService.h"
#import "DataCacheUseCaseImpl.h"

@interface PhotosService ()
@property (retain) PHPhotoLibrary *phPhotoLibrary;
@property (retain) id<DataCacheUseCase> _Nullable dataCacheUseCase;
@end

@implementation PhotosService

+ (PhotosService *)sharedInstance {
    static PhotosService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [PhotosService new];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.phPhotoLibrary = PHPhotoLibrary.sharedPhotoLibrary;
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_phPhotoLibrary release];
    [_dataCacheUseCase release];
    [super dealloc];
}

- (void)saveImage:(UIImage *)image fromViewController:(UIViewController *)viewController completionHandler:(void (^)(BOOL, NSError * _Nonnull))completionHandler {
    [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelAddOnly handler:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                [self.phPhotoLibrary performChanges:^{
                    [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                }
                                  completionHandler:completionHandler];
                break;
            default:
                [self askPopupAndOpenAppSettingsFromViewController:viewController];
                break;
        }
    }];
}

- (void)saveImageURL:(NSURL *)url fromViewController:(UIViewController *)viewController completionHandler:(void (^)(BOOL, NSError * _Nonnull))completionHandler {
    
    NSString *identity = url.absoluteString;
    
    [self.dataCacheUseCase dataCachesWithIdentity:identity completion:^(NSArray<NSData *> * _Nullable cachedDatas, NSError * _Nullable error) {
        
        NSData * _Nullable cachedData = cachedDatas.lastObject;
        
        if (cachedData) {
            UIImage *image = [UIImage imageWithData:cachedData];
            [self saveImage:image fromViewController:viewController completionHandler:completionHandler];
        } else {
            NSURLSession *sharedSession = NSURLSession.sharedSession;
            
            NSURLSessionTask *sessionTask = [sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    completionHandler(NO, error);
                } else if (data) {
                    [self.dataCacheUseCase createDataCache:data identity:url.absoluteString];
                    UIImage *image = [UIImage imageWithData:data];
                    [self saveImage:image fromViewController:viewController completionHandler:completionHandler];
                } else {
                    NSError *error = [[NSError alloc] initWithDomain:@"com.pookjw.StoneNamu.DataNil" code:100 userInfo:nil];
                    completionHandler(NO, error);
                    [error autorelease];
                }
            }];
            
            [sessionTask resume];
            [sharedSession finishTasksAndInvalidate];
        }
    }];
}

- (void)askPopupAndOpenAppSettingsFromViewController:(UIViewController *)viewController {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Need Photo Permission"
                                                                       message:@"Please Allow Photo Permission"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {}];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            [self openAppSettings];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:confirmAction];
        
        [viewController presentViewController:alert animated:YES completion:^{}];
    }];
}

- (void)openAppSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (url) {
        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {}];
    }
}

@end
