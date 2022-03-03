//
//  HSCardSavableImageView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import "HSCardSavableImageView.h"
#import "HSCardPromiseProvider.h"
#import "PhotosService.h"
#import "NSWindow+presentErrorAlert.h"
#import "NSImageView+setAsyncImage.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface HSCardSavableImageView () <NSDraggingSource>
@property (copy) HSCard * _Nullable hsCard;
@property (copy) HSCardGameModeSlugType _Nullable hsCardGameModeSlugType;
@property BOOL isGold;
@property (retain) id<HSCardUseCase> hsCardUseCase;
@end

@implementation HSCardSavableImageView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureMenu];
        
        HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
        self.hsCardUseCase = hsCardUseCase;
        [hsCardUseCase release];
    }
    
    return self;
}

- (instancetype)initWithHSCard:(HSCard *)hsCard hsGameModeSlugType:(nonnull HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold {
    self = [self init];
    
    if (self) {
        [self requestWithHSCard:hsCard hsGameModeSlugType:hsCardGameModeSlugType isGold:isGold];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_hsCardGameModeSlugType release];
    [_hsCardUseCase release];
    [super dealloc];
}

- (void)requestWithHSCard:(HSCard *)hsCard hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold {
    self.hsCard = hsCard;
    self.hsCardGameModeSlugType = hsCardGameModeSlugType;
    self.isGold = isGold;
    
    //
    
    NSURL * _Nullable url = [self.hsCardUseCase preferredImageURLOfHSCard:hsCard HSCardGameModeSlugType:hsCardGameModeSlugType isGold:isGold];
    
    if (url) {
        [self setAsyncImageWithURL:url indicator:YES];
    } else {
        [self clearSetAsyncImageContexts];
        self.image = nil;
    }
}

- (void)mouseDragged:(NSEvent *)event {
    [super mouseDragged:event];
    
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
    PhotosService *service = [[PhotosService alloc] initWithHSCards:[NSSet setWithObject:self.hsCard] hsGameModeSlugType:self.hsCardGameModeSlugType isGold:self.isGold];
    
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
