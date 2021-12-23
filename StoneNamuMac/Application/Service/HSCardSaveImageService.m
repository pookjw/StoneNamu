//
//  HSCardSaveImageService.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/22/21.
//

#import "HSCardSaveImageService.h"
#import "StorableMenuItem.h"
#import "NSTextField+setLabelStyle.h"
#import "NSImage+dataUsingType.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <StoneNamuResources/StoneNamuResources.h>

@interface HSCardSaveImageService () <NSOpenSavePanelDelegate>
@property (copy) NSSet<HSCard *> *hsCards;
@property (retain) NSSavePanel *panel;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@property (retain) NSOperationQueue *queue;
@end

@implementation HSCardSaveImageService

- (instancetype)initWithHSCards:(NSSet<HSCard *> *)hsCards {
    self = [self init];
    
    if (self) {
        self.hsCards = hsCards;
        
        //
        
        NSSavePanel *panel;
        
        if (hsCards.count == 1) {
            NSSavePanel *savePanel = [NSSavePanel savePanel];
            savePanel.nameFieldStringValue = hsCards.allObjects.firstObject.name;
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
        
        //
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        //
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCards release];
    [_panel release];
    [_dataCacheUseCase release];
    [_queue release];
    [super dealloc];
}

- (void)beginSheetModalForWindow:(NSWindow *)window completion:(HSCardSaveImageServiceSheetCompletion)completion {
    void (^handler)(NSModalResponse) = ^(NSModalResponse response) {
        [self saveHSCardsUsingResponse:response completion:completion];
    };
    
    if (window == nil) {
        [self.panel beginWithCompletionHandler:handler];
    } else {
        [self.panel beginSheetModalForWindow:window completionHandler:handler];
    }
}

- (void)saveHSCardsUsingResponse:(NSModalResponse)response completion:(HSCardSaveImageServiceSheetCompletion)completion {
    switch (response) {
        case NSModalResponseOK: {
            UTType * _Nullable selectedType = self.panel.allowedContentTypes.firstObject;
            
            if (selectedType == nil) {
                completion(NO, nil);
            }
            
            //
            
            NSURL * _Nullable url = nil;
            BOOL shouldAppendName;
            
            if ([self.panel isKindOfClass:[NSOpenPanel class]]) {
                NSOpenPanel *openPanel = (NSOpenPanel *)self.panel;
                url = openPanel.URLs.firstObject;
                shouldAppendName = YES;
            } else {
                url = self.panel.URL;
                shouldAppendName = NO;
            }
            
            if (url == nil) {
                completion(NO, nil);
            }
            
            //
            
            void (^writer)(NSData *, NSString *, void (^)(NSError * _Nullable)) = ^(NSData * data, NSString * name, void (^completion)(NSError * _Nullable)) {
                NSImage *image = [[NSImage alloc] initWithData:data];
                NSData *imageData = [image dataUsingUniformType:selectedType];
                [image release];
                
                NSError * _Nullable error = nil;
                
                NSURL *_url = url;
                
                if (shouldAppendName) {
                    _url = [[_url URLByAppendingPathComponent:name] URLByAppendingPathExtension:selectedType.preferredFilenameExtension];
                }
                
                [imageData writeToURL:_url options:0 error:&error];
                
                completion(error);
            };
            
            [self.queue addOperationWithBlock:^{
                SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:-((NSInteger)self.hsCards.count) + 1];
                NSError * __block _Nullable writeError = nil;
                
                [self.hsCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, BOOL * _Nonnull stop) {
                    if (writeError != nil) {
                        [semaphore signal];
                        return;
                    }
                    
                    [self.dataCacheUseCase dataCachesWithIdentity:obj.image.absoluteString completion:^(NSArray<NSData *> * _Nullable datas, NSError * _Nullable error) {
                        if (writeError != nil) {
                            [semaphore signal];
                            return;
                        }
                        
                        if (error != nil) {
                            writeError = [error copy];
                            [semaphore signal];
                            return;
                        }
                        
                        NSData * _Nullable data = datas.firstObject;
                        
                        if (data == nil) {
                            NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
                            
                            NSURLSessionTask *sessionTask = [session dataTaskWithURL:obj.image completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                if (writeError != nil) {
                                    [semaphore signal];
                                    return;
                                }
                                
                                if (error != nil) {
                                    writeError = [error copy];
                                    [semaphore signal];
                                    return;
                                }
                                
                                [self.dataCacheUseCase makeDataCache:data identity:obj.image.absoluteString completion:^{
                                    if (writeError != nil) {
                                        [semaphore signal];
                                        return;
                                    }
                                    
                                    writer(data, obj.name, ^(NSError * _Nullable error){
                                        if (error != nil) {
                                            writeError = [error copy];
                                        }
                                        [semaphore signal];
                                    });
                                }];
                            }];
                            
                            [sessionTask resume];
                        } else {
                            writer(data, obj.name, ^(NSError * _Nullable error){
                                if (error != nil) {
                                    writeError = [error copy];
                                }
                                [semaphore signal];
                            });
                        }
                    }];
                }];
                
                [semaphore wait];
                [semaphore release];
                
                if (writeError != nil) {
                    NSLog(@"%@", writeError);
                }
                
                completion((writeError != nil), [writeError autorelease]);
            }];
            
            break;
        }
        default: {
            completion(NO, nil);
            break;
        }
    }
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
