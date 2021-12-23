//
//  HSCardSavableImageView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import "HSCardSavableImageView.h"
#import "HSCardPromiseProvider.h"
#import "HSCardSaveImageService.h"
#import "NSWindow+presentErrorAlert.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface HSCardSavableImageView () <NSDraggingSource>
@property (copy) HSCard *hsCard;
@end

@implementation HSCardSavableImageView

- (instancetype)initWithHSCard:(HSCard *)hsCard {
    self = [self init];
    
    if (self) {
        self.hsCard = hsCard;
        [self configureMenu];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    
    HSCardPromiseProvider *pasteboardItem = [[HSCardPromiseProvider alloc] initWithHSCard:self.hsCard image:self.image];
    NSDraggingItem *draggingItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pasteboardItem];
    
    [draggingItem setDraggingFrame:self.bounds contents:self.image];
    
    [self beginDraggingSessionWithItems:@[draggingItem] event:event source:self];
    
    [pasteboardItem release];
    [draggingItem release];
}

- (void)configureMenu {
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *saveImageItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeySaveAsImage]
                                                      action:@selector(saveItemTriggered:)
                                               keyEquivalent:@""];
    saveImageItem.image = [NSImage imageWithSystemSymbolName:@"square.and.arrow.down" accessibilityDescription:nil];
    saveImageItem.target = self;
    
    menu.itemArray = @[saveImageItem];
    [saveImageItem release];
    
    self.menu = menu;
    [menu release];
}

- (void)saveItemTriggered:(NSMenuItem *)sender {
    HSCardSaveImageService *service = [[HSCardSaveImageService alloc] initWithHSCards:[NSSet setWithObject:self.hsCard]];
    
    [service beginSheetModalForWindow:self.window completion:^(BOOL success, NSError * _Nullable error) {
        if (error != nil) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self.window presentErrorAlertWithError:error];
            }];
        }
    }];
    
    [service release];
}

#pragma mark - NSDraggingSource

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    return NSDragOperationCopy;
}

@end
