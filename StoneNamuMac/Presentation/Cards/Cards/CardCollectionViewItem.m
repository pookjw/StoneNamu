//
//  CardCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/24/21.
//

#import "CardCollectionViewItem.h"
#import "NSImageView+setAsyncImage.h"

@interface CardCollectionViewItem ()
@property (copy) HSCard * _Nullable hsCard;
@property (weak) id<CardCollectionViewItemDelegate> delegte;
@end

@implementation CardCollectionViewItem

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGesture];
    [self clearContents];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearContents];
}

- (void)configureWithHSCard:(HSCard *)hsCard delegate:(nonnull id<CardCollectionViewItemDelegate>)delegate {
    self.hsCard = hsCard;
    self.delegte = delegate;
    
    [self.imageView setAsyncImageWithURL:hsCard.image indicator:YES];
}

- (void)clearContents {
    self.hsCard = nil;
    [self.imageView cancelAsyncImage];
    self.imageView.image = nil;
}

- (void)addGesture {
    NSClickGestureRecognizer *gesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTriggered:)];
    gesture.numberOfClicksRequired = 2;
    gesture.delaysPrimaryMouseButtonEvents = NO;
    
    [self.view addGestureRecognizer:gesture];
    
    [gesture release];
}

- (void)gestureTriggered:(NSClickGestureRecognizer *)sender {
    [self.delegte cardCollectionViewItem:self didDoubleClickWithRecognizer:sender];
}

@end
