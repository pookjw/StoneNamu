//
//  DeckAddCardCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "DeckAddCardCollectionViewItem.h"
#import "NSImageView+setAsyncImage.h"

@interface DeckAddCardCollectionViewItem ()
@property (assign) id<DeckAddCardCollectionViewItemDelegate> delegate;

@property (retain) IBOutlet NSTextField *countLabel;
@end


@implementation DeckAddCardCollectionViewItem

- (void)dealloc {
    [_hsCard release];
    [_countLabel release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.appearanceTypes = ClickableCollectionViewItemAppearanceTypeClicked | ClickableCollectionViewItemAppearanceTypeHighlighted;
    [self addGesture];
}

- (void)configureWithHSCard:(HSCard *)hsCard count:(NSUInteger)count delegate:(nonnull id<DeckAddCardCollectionViewItemDelegate>)delegate {
    [self->_hsCard release];
    self->_hsCard = [hsCard copy];
    self.delegate = delegate;
    
    self.countLabel.stringValue = [NSString stringWithFormat:@"%lu", count];
    [self.imageView setAsyncImageWithURL:self.hsCard.image indicator:YES];
}

- (void)addGesture {
    NSClickGestureRecognizer *gesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTriggered:)];
    gesture.numberOfClicksRequired = 1;
    gesture.delaysPrimaryMouseButtonEvents = NO;
    
    [self.view addGestureRecognizer:gesture];
    
    [gesture release];
}

- (void)gestureTriggered:(NSClickGestureRecognizer *)sender {
    [self.delegate deckAddCardCollectionViewItem:self didClickWithRecognizer:sender];
}

@end
