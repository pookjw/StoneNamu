//
//  DeckBaseCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import "DeckBaseCollectionViewItem.h"

@interface DeckBaseCollectionViewItem ()
@property (weak) id<DeckBaseCollectionViewItemDelegate> deckBaseCollectionViewItemDelegate;
@end

@implementation DeckBaseCollectionViewItem

- (void)dealloc {
    [_localDeck release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self clearContents];
    [self addGesture];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearContents];
}

- (void)configureWithLocalDeck:(LocalDeck *)localDeck deckBaseCollectionViewItemDelegate:(id<DeckBaseCollectionViewItemDelegate>)deckBaseCollectionViewItemDelegate {
    [self->_localDeck release];
    self->_localDeck = [localDeck retain];
    self.textField.stringValue = localDeck.name;
    self.deckBaseCollectionViewItemDelegate = deckBaseCollectionViewItemDelegate;
}

- (void)clearContents {
    self.textField.stringValue = @"";
}

- (void)addGesture {
    NSClickGestureRecognizer *gesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTriggered:)];
    gesture.numberOfClicksRequired = 2;
    gesture.delaysPrimaryMouseButtonEvents = NO;
    
    [self.view addGestureRecognizer:gesture];
    
    [gesture release];
}

- (void)gestureTriggered:(NSClickGestureRecognizer *)sender {
    [self.deckBaseCollectionViewItemDelegate deckBaseCollectionViewItem:self didDoubleClickWithRecognizer:sender];
}

@end
