//
//  DeckAddCardCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "DeckAddCardCollectionViewItem.h"
#import "NSImageView+setAsyncImage.h"

@interface DeckAddCardCollectionViewItem ()
@property (copy) HSCard * _Nullable hsCard;
@property (weak) id<DeckAddCardCollectionViewItemDelegate> delegte;
@end


@implementation DeckAddCardCollectionViewItem

-(void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGesture];
}

- (void)configureWithHSCard:(HSCard *)hsCard delegate:(nonnull id<DeckAddCardCollectionViewItemDelegate>)delegate {
    self.hsCard = hsCard;
    self.delegte = delegate;
    
    [self.imageView setAsyncImageWithURL:hsCard.image indicator:YES];
}

- (void)addGesture {
    NSClickGestureRecognizer *gesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTriggered:)];
    gesture.numberOfClicksRequired = 1;
    gesture.delaysPrimaryMouseButtonEvents = NO;
    
    [self.view addGestureRecognizer:gesture];
    
    [gesture release];
}

- (void)gestureTriggered:(NSClickGestureRecognizer *)sender {
    [self.delegte deckAddCardCollectionViewItem:self didClickWithRecognizer:sender];
}

@end
