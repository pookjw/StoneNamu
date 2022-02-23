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
@property (copy) NSDictionary<NSString *, NSImage *> * _Nullable images;
@property (copy) NSDictionary<NSString *, NSURL *> * _Nullable urls;
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
    }
    
    return self;
}

- (instancetype)initWithURLs:(NSDictionary<NSString *,NSURL *> *)urls {
    self = [self init];
    
    if (self) {
        self.urls = urls;
    }
    
    return self;
}

- (instancetype)initWithHSCards:(NSSet<HSCard *> *)hsCards {
    NSMutableDictionary<NSString *, NSURL *> *urls = [NSMutableDictionary<NSString *, NSURL *> new];
    
    [hsCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, BOOL * _Nonnull stop) {
        urls[obj.name] = obj.image;
    }];
    
    self = [self initWithURLs:urls];
    [urls release];
    
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

- (void)beginSheetModalForWindow:(NSWindow *)window completion:(PhotosServiceCompletion)completion {
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
                NSString * _Nullable inputName;
                
                if ([self.panel isKindOfClass:[NSOpenPanel class]]) {
                    NSOpenPanel *openPanel = (NSOpenPanel *)self.panel;
                    url = openPanel.URLs.firstObject;
                    inputName = nil;
                } else {
                    url = [self.panel.URL URLByDeletingLastPathComponent];
                    inputName = self.panel.URL.lastPathComponent;
                }
                
                if (url == nil) {
                    completion(NO, nil);
                    return;
                }
                
                //
                
                if (self.images != nil) {
                    [self saveImages:self.images toURL:url desiredName:inputName contentType:selectedType completion:completion];
                } else if (self.urls != nil) {
                    [self imagesFromURLs:self.urls completion:^(NSDictionary<NSString *, NSImage *> * _Nullable images, NSError * _Nullable error) {
                        if (error != nil) {
                            completion(NO, error);
                            return;
                        }
                        
                        self.images = images;
                        [self saveImages:self.images toURL:url desiredName:inputName contentType:selectedType completion:completion];
                    }];
                } else {
                    completion(NO, nil);
                    return;
                }
                
                break;
            }
            default: {
                completion(NO, nil);
                return;
            }
        }
    };
    
    [self configurePanel];
    
    if (window == nil) {
        [self.panel beginWithCompletionHandler:handler];
    } else {
        [self.panel beginSheetModalForWindow:window completionHandler:handler];
    }
}

- (void)beginSharingServiceOfView:(NSView *)view {
    [self.queue addBarrierBlock:^{
        if (self.images != nil) {
            [self shareImages:self.images.allValues ofView:view];
        } else if (self.urls != nil) {
            [self imagesFromURLs:self.urls completion:^(NSDictionary<NSString *, NSImage *> * _Nullable images, NSError * _Nullable error) {
                self.images = images;
                [self shareImages:images.allValues ofView:view];
            }];
        } else {
            
        }
    }];
}

- (void)saveImages:(NSDictionary<NSString *, NSImage *> *)images toURL:(NSURL *)url desiredName:(NSString * _Nullable)desiredName contentType:(UTType *)contentType completion:(PhotosServiceCompletion)completion {
    [self.queue addBarrierBlock:^{
        NSError * __block _Nullable writeError = nil;
        
        [images enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSImage * _Nonnull obj, BOOL * _Nonnull stop) {
            NSData *imageData = [obj dataUsingUniformType:contentType];
            NSURL *_url;
            
            if (desiredName != nil) {
                _url = [url URLByAppendingPathComponent:desiredName];
            } else {
                _url = [[url URLByAppendingPathComponent:key] URLByAppendingPathExtension:contentType.preferredFilenameExtension];
            }
            
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

- (void)shareImages:(NSArray<NSImage *> *)images ofView:(NSView *)view {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:images];
        [picker showRelativeToRect:NSZeroRect ofView:view preferredEdge:NSRectEdgeMinX];
        [picker release];
    }];
}

- (void)imagesFromURLs:(NSDictionary<NSString *, NSURL *> *)urls completion:(void (^)(NSDictionary<NSString *, NSImage *> * _Nullable images, NSError * _Nullable error))completion {
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
        
        NSMutableDictionary<NSString *, NSImage *> *images = [NSMutableDictionary<NSString *, NSImage *> new];
        
        [results enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSData * _Nonnull obj, BOOL * _Nonnull stop) {
            NSImage *image = [[NSImage alloc] initWithData:obj];
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

- (void)configurePanel {
    NSUInteger itemCount;
    NSString * _Nullable name;
    
    if (self.images != nil) {
        itemCount = self.images.count;
        name = self.images.allKeys.firstObject;
    } else if (self.urls != nil) {
        itemCount = self.urls.count;
        name = self.urls.allKeys.firstObject;
    } else {
        itemCount = 0;
        name = nil;
    }
    
    NSSavePanel *panel;
    
    if (itemCount == 1) {
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        savePanel.nameFieldStringValue = name;
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
    NSMutableArray<StorableMenuItem *> *itemArray = [NSMutableArray<StorableMenuItem *> new];
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
