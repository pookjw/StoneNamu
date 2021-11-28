//
//  DeckDetailsWindow.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import "DeckDetailsWindow.h"
#import "DeckDetailsViewController.h"
#import "NSProcessInfo+isEnabledRestoration.h"
#import "NSViewController+loadViewIfNeeded.h"

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckDetailsWindow = @"NSUserInterfaceItemIdentifierDeckDetailsWindow";

@interface DeckDetailsWindow () <NSWindowDelegate>
@property (retain) DeckDetailsViewController *deckDetailsViewController;
@end

@implementation DeckDetailsWindow

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck {
    self = [self init];
    
    if (self) {
        [self setAttributes];
        [self configureDeckDetailsViewControllerWithLocalDeck:localDeck];
    }
    
    return self;
}

- (void)dealloc {
    [_deckDetailsViewController release];
    [super dealloc];
}

- (void)setAttributes {
    self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled;
    self.movableByWindowBackground = YES;
    self.contentMinSize = NSMakeSize(1000, 600);
    self.releasedWhenClosed = NO;
    self.titlebarAppearsTransparent = NO;
    self.titleVisibility = NSWindowTitleHidden;
    self.delegate = self;
    self.restorable = NSProcessInfo.processInfo.isEnabledRestoration;
//    self.restorationClass = [MainWindowRestoration class];
    self.identifier = NSUserInterfaceItemIdentifierDeckDetailsWindow;
}

- (void)configureDeckDetailsViewControllerWithLocalDeck:(LocalDeck *)localDeck {
    DeckDetailsViewController *deckDetailsViewController = [[DeckDetailsViewController alloc] initWithLocalDeck:localDeck presentEditorIfNoCards:YES];
    self.deckDetailsViewController = deckDetailsViewController;
    [deckDetailsViewController loadViewIfNeeded];
    self.contentViewController = deckDetailsViewController;
    [deckDetailsViewController release];
}

@end
