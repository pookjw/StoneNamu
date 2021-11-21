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

@interface CardDetailsWindow () <NSWindowDelegate>
@property (retain) CardDetailsViewController *cardDetailsViewController;
@end

@implementation CardDetailsWindow

- (instancetype)initWithHSCard:(HSCard *)hsCard {
    self = [self init];
    
    if (self) {
        [self setAttributes];
        [self configureCardDetailsViewControllerWithHSCard:hsCard];
    }
    
    return self;
}

- (void)dealloc {
    [_cardDetailsViewController release];
    [super dealloc];
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
//        self.restorationClass = [MainWindowRestoration class];
    self.identifier = NSUserInterfaceItemIdentifierCardDetailsWindow;
}

- (void)configureCardDetailsViewControllerWithHSCard:(HSCard *)hsCard; {
    CardDetailsViewController *cardDetailsViewController = [[CardDetailsViewController alloc] initWithHSCard:hsCard];
    self.cardDetailsViewController = cardDetailsViewController;
    [cardDetailsViewController loadViewIfNeeded];
    self.contentViewController = cardDetailsViewController;
    [cardDetailsViewController release];
}

#pragma mark - NSWindowDelegate

- (void)window:(NSWindow *)window willEncodeRestorableState:(NSCoder *)state {
    
}

- (void)window:(NSWindow *)window didDecodeRestorableState:(NSCoder *)state {
    
}

@end
