//
//  DeckDetailsWindow.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import "DeckDetailsWindow.h"
#import "DeckDetailsSplitViewController.h"
#import "NSProcessInfo+isEnabledRestoration.h"
#import "NSViewController+loadViewIfNeeded.h"
#import "DeckDetailsWindowRestoration.h"

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckDetailsWindow = @"NSUserInterfaceItemIdentifierDeckDetailsWindow";

@interface DeckDetailsWindow () <NSWindowDelegate>
@property (retain) DeckDetailsSplitViewController *deckDetailsSplitViewController;
@end

@implementation DeckDetailsWindow

- (instancetype)initWithLocalDeck:(LocalDeck * _Nullable)localDeck {
    self = [self init];
    
    if (self) {
        [self setAttributes];
        [self configureDeckDetailsSplitViewControllerWithLocalDeck:localDeck];
    }
    
    return self;
}

- (void)dealloc {
    [_deckDetailsSplitViewController release];
    [super dealloc];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder backgroundQueue:(NSOperationQueue *)queue {
    [super encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    [self.deckDetailsSplitViewController encodeRestorableStateWithCoder:coder backgroundQueue:queue];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    [self.deckDetailsSplitViewController restoreStateWithCoder:coder];
}

- (void)setAttributes {
    self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled;
    self.movableByWindowBackground = YES;
    self.contentMinSize = NSMakeSize(1000, 600);
    self.releasedWhenClosed = NO;
    self.titlebarAppearsTransparent = NO;
    self.titleVisibility = NSWindowTitleVisible;
    self.delegate = self;
    self.restorable = NSProcessInfo.processInfo.isEnabledRestoration;
    self.restorationClass = [DeckDetailsWindowRestoration class];
    self.identifier = NSUserInterfaceItemIdentifierDeckDetailsWindow;
}

- (void)configureDeckDetailsSplitViewControllerWithLocalDeck:(LocalDeck * _Nullable)localDeck {
    DeckDetailsSplitViewController *deckDetailsSplitViewController = [[DeckDetailsSplitViewController alloc] initWithLocalDeck:localDeck];
    [deckDetailsSplitViewController loadViewIfNeeded];
    self.contentViewController = deckDetailsSplitViewController;
    self.deckDetailsSplitViewController = deckDetailsSplitViewController;
    [deckDetailsSplitViewController release];
}

@end
