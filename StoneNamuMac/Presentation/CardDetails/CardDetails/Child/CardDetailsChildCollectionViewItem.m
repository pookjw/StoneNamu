//
//  CardDetailsChildCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import "CardDetailsChildCollectionViewItem.h"
#import "NSImageView+setAsyncImage.h"
#import "HSCardPopoverDetailView.h"

@interface CardDetailsChildCollectionViewItem ()
@property (retain) IBOutlet HSCardPopoverDetailView *hsCardPopoverDetailView;
@property (copy) HSCard * _Nullable hsCard;
@property (assign) id<CardDetailsChildCollectionViewItemDelegate> delegate;
@end

@implementation CardDetailsChildCollectionViewItem

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

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)configureWithHSCard:(HSCard *)hsCard hsCardGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold imageURL:(NSURL * _Nullable)imageURL delegate:(id<CardDetailsChildCollectionViewItemDelegate>)delegate {
    self.hsCard = hsCard;
    self.delegate = delegate;
    
    [self.hsCardPopoverDetailView setHSCard:hsCard hsGameModeSlugType:hsCardGameModeSlugType isGold:isGold];
    
    //
    
    if (imageURL) {
        [self.imageView setAsyncImageWithURL:imageURL indicator:YES];
    } else {
        [self.imageView clearSetAsyncImageContexts];
        self.imageView.image = nil;
    }
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
    [self.delegate cardDetailsChildrenContentImageContentCollectionViewItem:self didDoubleClickWithRecognizer:sender];
}

@end
