//
//  CardDetailsChildrenContentImageContentCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import "CardDetailsChildrenContentImageContentCollectionViewItem.h"
#import "NSImageView+setAsyncImage.h"

@interface CardDetailsChildrenContentImageContentCollectionViewItem ()
@property (copy) HSCard * _Nullable hsCard;
@property (weak) id<CardDetailsChildrenContentImageContentCollectionViewItemDelegate> delegate;
@end

@implementation CardDetailsChildrenContentImageContentCollectionViewItem

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

- (void)configureWithHSCard:(HSCard *)hsCard delegate:(nonnull id<CardDetailsChildrenContentImageContentCollectionViewItemDelegate>)delegate {
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
