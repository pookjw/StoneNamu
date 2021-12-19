//
//  DeckDetailsCardCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import "DeckDetailsCardCollectionViewItem.h"
#import <QuartzCore/QuartzCore.h>
#import "NSImageView+setAsyncImage.h"

@interface DeckDetailsCardCollectionViewItem ()
@property (copy) HSCard *hsCard;
@property (assign) id<DeckDetailsCardCollectionViewItemDelegate> delegate;
@property (retain) IBOutlet NSView *containerView;
@property (retain) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (retain) IBOutlet NSView *manaCostContainerView;
@property (retain) IBOutlet NSLayoutConstraint *manaCostContainerViewWidthConstraint;
@property (retain) IBOutlet NSTextField *manaCostLabel;
@property (retain) IBOutlet NSTextField *nameLabel;
@property (retain) IBOutlet NSView *countContainerView;
@property (retain) IBOutlet NSLayoutConstraint *countContainerViewWidthConstraint;
@property (retain) IBOutlet NSTextField *countLabel;
@property (retain) CAGradientLayer *imageViewGradientLayer;
@end

@implementation DeckDetailsCardCollectionViewItem

- (void)dealloc {
    [_hsCard release];
    [_containerView release];
    [_containerViewHeightConstraint release];
    [_manaCostContainerView release];
    [_manaCostContainerViewWidthConstraint release];
    [_manaCostLabel release];
    [_nameLabel release];
    [_countContainerView release];
    [_countContainerViewWidthConstraint release];
    [_countLabel release];
    [_imageViewGradientLayer release];
    [super dealloc];
}

- (void)viewDidLayout {
    [super viewDidLayout];
    [self updateGradientLayer];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGesture];
    [self configureImageViewGradientLayer];
    [self setAttributes];
    [self clearContents];
}

- (void)prepareForReuse {
    [super prepareForReuse];
//    [self clearContents];
}

- (void)configureWithHSCard:(HSCard *)hsCard hsCardCount:(NSUInteger)hsCardCount delegate:(nonnull id<DeckDetailsCardCollectionViewItemDelegate>)delegate {
    self.countLabel.stringValue = [NSString stringWithFormat:@"%lu", hsCardCount];
    
    if (![hsCard isEqual:self.hsCard]) {
        self.manaCostLabel.stringValue = [NSString stringWithFormat:@"%lu", hsCard.manaCost];
        self.nameLabel.stringValue = hsCard.name;
        [self.imageView setAsyncImageWithURL:hsCard.cropImage indicator:YES];
    }
    
    self.hsCard = hsCard;
    self.delegate = delegate;
}

- (void)addGesture {
    NSClickGestureRecognizer *gesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTriggered:)];
    gesture.numberOfClicksRequired = 2;
    gesture.delaysPrimaryMouseButtonEvents = NO;
    
    [self.view addGestureRecognizer:gesture];
    
    [gesture release];
}

- (void)gestureTriggered:(NSClickGestureRecognizer *)sender {
    [self.delegate deckDetailsCardCollectionViewItem:self didDoubleClickWithRecognizer:sender];
}

- (void)configureImageViewGradientLayer {
    CAGradientLayer *imageViewGradientLayer = [CAGradientLayer new];
    self.imageViewGradientLayer = imageViewGradientLayer;
    imageViewGradientLayer.colors = @[
        (id)[NSColor.whiteColor colorWithAlphaComponent:0].CGColor,
        (id)NSColor.whiteColor.CGColor
    ];
    imageViewGradientLayer.startPoint = CGPointMake(0, 0);
    imageViewGradientLayer.endPoint = CGPointMake(0.8, 0);
    self.imageView.wantsLayer = YES;
    self.imageView.layer.mask = imageViewGradientLayer;
    [imageViewGradientLayer release];
}


- (void)setAttributes {
    self.manaCostContainerView.wantsLayer = YES;
    self.manaCostContainerView.layer.backgroundColor = NSColor.systemBlueColor.CGColor;
}

- (void)clearContents {
    self.manaCostLabel.stringValue = @"";
    self.nameLabel.stringValue = @"";
    self.countLabel.stringValue = @"";
    self.imageView.image = nil;
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.imageViewGradientLayer.frame = self.imageView.bounds;
    [CATransaction commit];
}

@end
