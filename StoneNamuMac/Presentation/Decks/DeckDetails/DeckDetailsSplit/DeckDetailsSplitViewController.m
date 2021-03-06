//
//  DeckDetailsSplitViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import "DeckDetailsSplitViewController.h"
#import "NSViewController+loadViewIfNeeded.h"

@interface DeckDetailsSplitViewController ()
@end

@implementation DeckDetailsSplitViewController

- (instancetype)initWithLocalDeck:(LocalDeck * _Nullable)localDeck {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        [self configureViewControllersWithLocalDeck:localDeck];
    }
    
    return self;
}

- (void)dealloc {
    [_deckAddCardsViewController release];
    [_deckDetailsViewController release];
    [super dealloc];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder backgroundQueue:(NSOperationQueue *)queue {
    [super encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    [self.deckAddCardsViewController encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    [self.deckDetailsViewController encodeRestorableStateWithCoder:coder backgroundQueue:queue];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    [self.deckAddCardsViewController restoreStateWithCoder:coder];
    [self.deckDetailsViewController restoreStateWithCoder:coder];
}

- (void)configureViewControllersWithLocalDeck:(LocalDeck * _Nullable)localDeck {
    DeckAddCardsViewController *deckAddCardsViewController = [[DeckAddCardsViewController alloc] initWithLocalDeck:localDeck];
    [deckAddCardsViewController loadViewIfNeeded];
    NSSplitViewItem *deckAddCardsSplitViewItem = [NSSplitViewItem contentListWithViewController:deckAddCardsViewController];
    [self addSplitViewItem:deckAddCardsSplitViewItem];
    
    //
    
    DeckDetailsViewController *deckDetailsViewController = [[DeckDetailsViewController alloc] initWithLocalDeck:localDeck];
    [deckDetailsViewController loadViewIfNeeded];
    NSSplitViewItem *deckDetailsSplitViewItem = [NSSplitViewItem contentListWithViewController:deckDetailsViewController];
    [self addSplitViewItem:deckDetailsSplitViewItem];
    
    //
    
    [self->_deckAddCardsViewController release];
    self->_deckAddCardsViewController = [deckAddCardsViewController retain];
    [self->_deckDetailsViewController release];
    self->_deckDetailsViewController = [deckDetailsViewController retain];
    [deckAddCardsViewController release];
    [deckDetailsViewController release];
}

- (void)paste:(id)sender {
    [self.deckDetailsViewController performSelector:@selector(paste:) withObject:sender];
}

#pragma mark - NSSplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
    return NO;
}

@end
