//
//  PhotosService.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/25/21.
//

#import "PhotosService.h"
#import "StorableMenuItem.h"
#import "NSTextField+setLabelStyle.h"
#import "NSImage+dataUsingType.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <StoneNamuResources/StoneNamuResources.h>

@interface PhotosService () <NSOpenSavePanelDelegate>
@property (copy) NSDictionary<NSString *,NSImage *> * _Nullable images;
@property (copy) NSDictionary<NSString *,NSURL *> * _Nullable urls;
@property (retain) NSSavePanel *panel;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@property (retain) NSOperationQueue *queue;
@end

@implementation PhotosService

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.images = nil;
        self.urls = nil;
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
    }
    
    return self;
}

- (instancetype)initWithImages:(NSDictionary<NSString *,NSImage *> *)images {
    self = [self init];
    
    if (self) {
        self.images = images;
        [self configurePanelWithNames:images.allKeys];
    }
    
    return self;
}

- (instancetype)initWithURLs:(NSDictionary<NSString *,NSURL *> *)urls {
    self = [self init];
    
    if (self) {
        self.urls = urls;
        [self configurePanelWithNames:urls.allKeys];
    }
    
    return self;
}

- (void)dealloc {
    [_images release];
    [_urls release];
    [_panel release];
    [_dataCacheUseCase release];
    [_queue release];
    [super dealloc];
}

- (void)beginSheetModalForWindow:(NSWindow *)window completion:(PhotosServiceSaveImageCompletion)completion {
    void (^handler)(NSModalResponse) = ^(NSModalResponse response) {
        switch (response) {
            case NSModalResponseOK: {
                UTType * _Nullable selectedType = self.panel.allowedContentTypes.firstObject;
                
                if (selectedType == nil) {
                    completion(NO, nil);
                    return;
                }
                
                //
                
                NSURL * _Nullable url;
                
                if ([self.panel isKindOfClass:[NSOpenPanel class]]) {
                    NSOpenPanel *openPanel = (NSOpenPanel *)self.panel;
                    url = openPanel.URLs.firstObject;
                } else {
                    url = [self.panel.URL URLByDeletingLastPathComponent];
                }
                
                if (url == nil) {
                    completion(NO, nil);
                    return;
                }
                
                //
                
                NSMutableDictionary<NSString *, NSImage *> * _Nullable images = nil;
                NSMutableDictionary<NSString *, NSURL *> * _Nullable urls = nil;
                
                if (self.images != nil) {
                    images = [[@{} mutableCopy] autorelease];
                    
                    [self.images enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSImage * _Nonnull obj, BOOL * _Nonnull stop) {
                        NSString *name = [NSString stringWithFormat:@"%@.%@", key, selectedType.preferredFilenameExtension];
                        images[name] = obj;
                    }];
                }
                
                if (self.urls != nil) {
                    urls = [[@{} mutableCopy] autorelease];
                    
                    [self.urls enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSURL * _Nonnull obj, BOOL * _Nonnull stop) {
                        NSString *name = [NSString stringWithFormat:@"%@.%@", key, selectedType.preferredFilenameExtension];
                        urls[name] = obj;
                    }];
                }
                
                //
                
                if (images != nil) {
                    [self saveImages:images toURL:url contentType:selectedType completion:completion];
                } else if (urls != nil) {
                    [self saveImagesFromURLs:urls toURL:url contentType:selectedType completion:completion];
                } else {
                    completion(NO, nil);
                }
                
                break;
            }
            default: {
                completion(NO, nil);
                break;
            }
        }
    };
    
    if (window == nil) {
        [self.panel beginWithCompletionHandler:handler];
    } else {
        [self.panel beginSheetModalForWindow:window completionHandler:handler];
    }
}

- (void)saveImages:(NSDictionary<NSString *, NSImage *> *)images toURL:(NSURL *)url contentType:(UTType *)contentType completion:(PhotosServiceSaveImageCompletion)completion {
    [self.queue addBarrierBlock:^{
        NSError * __block _Nullable writeError = nil;
        
        [images enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSImage * _Nonnull obj, BOOL * _Nonnull stop) {
            NSData *imageData = [obj dataUsingUniformType:contentType];
            NSURL *_url = [url URLByAppendingPathComponent:key];
            NSError * _Nullable error = nil;
            
            [imageData writeToURL:_url options:0 error:&error];
            
            if (error != nil) {
                writeError = [error copy];
                *stop = YES;
            }
        }];
        
        completion((writeError != nil), [writeError autorelease]);
    }];
}

- (void)saveImagesFromURLs:(NSDictionary<NSString *, NSURL *> *)urls toURL:(NSURL *)url contentType:(UTType *)contentType completion:(PhotosServiceSaveImageCompletion)completion {
    [self.queue addBarrierBlock:^{
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:-((NSInteger)self.urls.count) + 1];
        NSMutableDictionary<NSString *, NSData *> *results = [@{} mutableCopy];
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
                } else {
                    results[key] = data;
                    [semaphore signal];
                }
            }];
        }];
        
        [semaphore wait];
        [semaphore release];
        
        //
        
        NSMutableDictionary<NSString *, NSImage *> *images = [@{} mutableCopy];
        
        [results enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSData * _Nonnull obj, BOOL * _Nonnull stop) {
            NSImage *image = [[NSImage alloc] initWithData:obj];
            images[key] = image;
            [image release];
        }];
        
        [results release];
        
        //
        
        if (writeError != nil) {
            [images release];
            completion(NO, [writeError autorelease]);
        } else {
            [self saveImages:[images autorelease]
                       toURL:url
                 contentType:contentType
                  completion:completion];
        }
    }];
}

- (void)configurePanelWithNames:(NSArray<NSString *> *)names {
    NSSavePanel *panel;
    
    if (names.count == 1) {
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        savePanel.nameFieldStringValue = names.firstObject;
        savePanel.allowsOtherFileTypes = YES;
        
        panel = savePanel;
    } else {
        NSOpenPanel *openPanel = [NSOpenPanel openPanel];
        openPanel.allowsMultipleSelection = NO;
        openPanel.canChooseFiles = NO;
        openPanel.canChooseDirectories = YES;
        
        panel = openPanel;
    }
    
    panel.delegate = self;
    panel.canCreateDirectories = YES;
    
    NSArray<UTType *> *contentTypes = @[UTTypeTIFF, UTTypeBMP, UTTypeJPEG, UTTypePNG];
    UTType *defaultType = UTTypePNG;
    panel.allowedContentTypes = @[defaultType];
    panel.accessoryView = [self makeFormatSelectionAccessoryViewWithContentTypes:contentTypes withDefaultType:defaultType];
    
    self.panel = panel;
}

- (NSView *)makeFormatSelectionAccessoryViewWithContentTypes:(NSArray<UTType *> *)contentTypes withDefaultType:(UTType *)defaultType {
    NSStackView *stackView = [NSStackView new];
    stackView.alignment = NSLayoutAttributeCenterX;
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    
    //
    
    NSTextField *label = [NSTextField new];
    [label setLabelStyle];
    label.stringValue = [ResourcesService localizationForKey:LocalizableKeyFileFormat];
    
    [stackView addArrangedSubview:label];
    [label release];
    
    //

    NSMenu *formatMenu = [NSMenu new];
    NSMutableArray<StorableMenuItem *> *itemArray = [@[] mutableCopy];
    StorableMenuItem * __block _Nullable defaultItem = nil;
    
    [contentTypes enumerateObjectsUsingBlock:^(UTType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StorableMenuItem *menuItem = [[StorableMenuItem alloc] initWithTitle:obj.preferredFilenameExtension
                                                                      action:@selector(didChangeFormatMenuSelection:)
                                                               keyEquivalent:@""
                                                                    userInfo:@{@"key": obj}];
        menuItem.target = self;
        [itemArray addObject:menuItem];
        
        if ([obj isEqual:defaultType]) {
            defaultItem = menuItem;
        }
        
        [menuItem release];
    }];
    
    formatMenu.itemArray = itemArray;
    [itemArray release];
    
    //

    NSPopUpButton *formatButton = [NSPopUpButton new];
    formatButton.pullsDown = NO;
    formatButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [formatButton.widthAnchor constraintEqualToConstant:150.0f]
    ]];
    formatButton.menu = formatMenu;
    [formatMenu release];
    
    if (defaultItem != nil) {
        [formatButton selectItem:defaultItem];
    }
    
    [stackView addArrangedSubview:formatButton];
    [formatButton release];
    
    return [stackView autorelease];
}

- (void)didChangeFormatMenuSelection:(StorableMenuItem *)sender {
    UTType * _Nullable type = sender.userInfo.allValues.firstObject;
    
    if (type != nil) {
        self.panel.allowedContentTypes = @[type];
    }
}

#pragma mark - NSOpenSavePanelDelegate

@end
