//
//  CardDetailsWindow.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import "CardDetailsWindow.h"
#import "NSViewController+loadViewIfNeeded.h"
#import "CardDetailsViewController.h"
#import "NSProcessInfo+isEnabledRestoration.h"
#import "CardDetailsWindowRestoration.h"

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierCardDetailsWindow = @"NSUserInterfaceItemIdentifierCardDetailsWindow";

@interface CardDetailsWindow () <NSWindowDelegate>
@property (retain) CardDetailsViewController *cardDetailsViewController;
@end

@implementation CardDetailsWindow

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureCardDetailsViewController];
    }
    
    return self;
}

- (instancetype)initWithHSCard:(HSCard *)hsCard {
    self = [self init];
    
    if (self) {
        [self.cardDetailsViewController requestWithHSCard:hsCard];
    }
    
    return self;
}

- (void)dealloc {
    [_cardDetailsViewController release];
    [super dealloc];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder backgroundQueue:(NSOperationQueue *)queue {
    [super encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    [self.cardDetailsViewController encodeRestorableStateWithCoder:coder backgroundQueue:queue];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    [self.cardDetailsViewController restoreStateWithCoder:coder];
}

- (void)setAttributes {
    self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskTitled | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable;
    self.movableByWindowBackground = NO;
    self.releasedWhenClosed = NO;
    self.opaque = YES;
    self.contentMinSize = NSMakeSize(800.0f, 600.0f);
    self.titlebarAppearsTransparent = YES;
    self.titleVisibility = NSWindowTitleVisible;
    self.delegate = self;
    self.restorable = NSProcessInfo.processInfo.isEnabledRestoration;
    self.restorationClass = [CardDetailsWindowRestoration class];
    self.identifier = NSUserInterfaceItemIdentifierCardDetailsWindow;
}

- (void)configureCardDetailsViewController; {
    CardDetailsViewController *cardDetailsViewController = [[CardDetailsViewController alloc] initWithHSCard:nil];
    [cardDetailsViewController loadViewIfNeeded];
    self.contentViewController = cardDetailsViewController;
    self.cardDetailsViewController = cardDetailsViewController;
    [cardDetailsViewController release];
}

#pragma mark - NSWindowDelegate

- (void)window:(NSWindow *)window willEncodeRestorableState:(NSCoder *)state {
    
}

- (void)window:(NSWindow *)window didDecodeRestorableState:(NSCoder *)state {
    
}

@end
