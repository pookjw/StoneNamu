//
//  HSCardSaveImageService.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/22/21.
//

#import "HSCardSaveImageService.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface HSCardSaveImageService () <NSOpenSavePanelDelegate>
@property (copy) NSSet<HSCard *> *hsCards;
@property (retain) NSSavePanel *savePanel;
@end

@implementation HSCardSaveImageService

- (instancetype)initWithHSCards:(NSSet<HSCard *> *)hsCards {
    self = [self init];
    
    if (self) {
        self.hsCards = hsCards;
        
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        savePanel.delegate = self;
        savePanel.canCreateDirectories = YES;
        savePanel.allowedContentTypes = @[UTTypeTIFF, UTTypeBMP, UTTypeJPEG, UTTypePNG];
        
        self.savePanel = savePanel;
    }
    
    return self;
}

- (void)dealloc {
    [_hsCards release];
    [_savePanel release];
    [super dealloc];
}

- (void)beginSheetModalForWindow:(NSWindow * _Nullable)window completionHandler:(void (^)(NSModalResponse))handler {
    if (window == nil) {
        [self.savePanel beginWithCompletionHandler:handler];
    } else {
        [self.savePanel beginSheetModalForWindow:window completionHandler:handler];
    }
}

#pragma mark - NSOpenSavePanelDelegate

- (NSString *)panel:(id)sender userEnteredFilename:(NSString *)filename confirmed:(BOOL)okFlag {
    return filename;
}

@end
