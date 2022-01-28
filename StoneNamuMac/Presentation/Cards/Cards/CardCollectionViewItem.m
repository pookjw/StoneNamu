//
//  CardCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/24/21.
//

#import "CardCollectionViewItem.h"
#import "NSImageView+setAsyncImage.h"
#import "HSCardPopoverDetailView.h"

@interface CardCollectionViewItem ()
@property (retain) IBOutlet HSCardPopoverDetailView *hsCardPopoverDetailView;
@property (copy) HSCard * _Nullable hsCard;
@property (assign) id<CardCollectionViewItemDelegate> delegte;
@end

@implementation CardCollectionViewItem

- (void)dealloc {
    [_hsCardPopoverDetailView release];
    [_hsCard release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setAttributes];
    [self addGesture];
}

- (void)configureWithHSCard:(HSCard *)hsCard delegate:(nonnull id<CardCollectionViewItemDelegate>)delegate {
    self.hsCard = hsCard;
    self.delegte = delegate;
    
    self.hsCardPopoverDetailView.hsCard = hsCard;
    [self.imageView setAsyncImageWithURL:hsCard.image indicator:YES];
}

- (void)setAttributes {
    self.view.wantsLayer = YES;
    self.view.layer.cornerRadius = 15.0f;
    self.view.layer.cornerCurve = kCACornerCurveContinuous;
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
