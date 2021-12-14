//
//  CardDetailsChildCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import "CardDetailsChildCollectionViewItem.h"
#import "NSImageView+setAsyncImage.h"

@interface CardDetailsChildCollectionViewItem ()
@property (copy) HSCard * _Nullable hsCard;
@property (assign) id<CardDetailsChildCollectionViewItemDelegate> delegate;
@end

@implementation CardDetailsChildCollectionViewItem

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGesture];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)configureWithHSCard:(HSCard *)hsCard delegate:(nonnull id<CardDetailsChildCollectionViewItemDelegate>)delegate {
    self.hsCard = hsCard;
    self.delegate = delegate;
    
    [self.imageView setAsyncImageWithURL:hsCard.image indicator:YES];
}

- (void)addGesture {
    NSClickGestureRecognizer *gesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTriggered:)];
    gesture.numberOfClicksRequired = 2;
    gesture.delaysPrimaryMouseButtonEvents = NO;
    
    [self.view addGestureRecognizer:gesture];
    
    [gesture release];
}

- (void)gestureTriggered:(NSClickGestureRecognizer *)sender {
    [self.delegate cardDetailsChildrenContentImageContentCollectionViewItem:self didDoubleClickWithRecognizer:sender];
}

@end
