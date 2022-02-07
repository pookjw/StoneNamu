//
//  DeckDetailsCardCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import "DeckDetailsCardCollectionViewItem.h"
#import <QuartzCore/QuartzCore.h>
#import "NSImageView+setAsyncImage.h"
#import "HSCardPopoverDetailView.h"

@interface DeckDetailsCardCollectionViewItem ()
@property (copy) HSCard *hsCard;
@property (assign) id<DeckDetailsCardCollectionViewItemDelegate> delegate;
@property (retain) IBOutlet NSView *containerView;
@property (retain) IBOutlet NSImageView *cardImageView;
@property (retain) IBOutlet NSBox *manaCostContainerBox;
@property (retain) IBOutlet NSLayoutConstraint *manaCostContainerViewWidthConstraint;
@property (retain) IBOutlet NSTextField *manaCostLabel;
@property (retain) IBOutlet NSTextField *nameLabel;
@property (retain) IBOutlet NSBox *countContainerBox;
@property (retain) IBOutlet NSLayoutConstraint *countContainerViewWidthConstraint;
@property (retain) IBOutlet NSTextField *countLabel;
@property (retain) IBOutlet HSCardPopoverDetailView *hsCardPopoverDetailView;
@property (retain) CAGradientLayer *cardImageViewGradientLayer;
@end

@implementation DeckDetailsCardCollectionViewItem

- (void)dealloc {
    [_hsCard release];
    [_containerView release];
    [_cardImageView release];
    [_manaCostContainerBox release];
    [_manaCostContainerViewWidthConstraint release];
    [_manaCostLabel release];
    [_nameLabel release];
    [_countContainerBox release];
    [_countContainerViewWidthConstraint release];
    [_countLabel release];
    [_hsCardPopoverDetailView release];
    [_cardImageViewGradientLayer release];
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
    [self bind];
}

- (void)prepareForReuse {
    [super prepareForReuse];
//    [self clearContents];
}

- (void)configureWithHSCard:(HSCard *)hsCard isLegendary:(BOOL)isLegendary hsCardCount:(NSUInteger)hsCardCount delegate:(nonnull id<DeckDetailsCardCollectionViewItemDelegate>)delegate {
    
    self.hsCardPopoverDetailView.hsCard = hsCard;
    
    if (![hsCard isEqual:self.hsCard]) {
        self.manaCostLabel.stringValue = [NSString stringWithFormat:@"%lu", hsCard.manaCost];
        self.nameLabel.stringValue = hsCard.name;
        [self.cardImageView setAsyncImageWithURL:hsCard.cropImage indicator:YES];
    }
    
    if ((isLegendary) && (hsCardCount == 1)) {
        self.countLabel.stringValue = @"★";
        self.countLabel.textColor = NSColor.systemOrangeColor;
    } else {
        self.countLabel.stringValue = [NSString stringWithFormat:@"%lu", hsCardCount];
        self.countLabel.textColor = NSColor.whiteColor;
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
    CAGradientLayer *cardImageViewGradientLayer = [CAGradientLayer new];

    cardImageViewGradientLayer.colors = @[
        (id)[NSColor.whiteColor colorWithAlphaComponent:0].CGColor,
        (id)NSColor.whiteColor.CGColor
    ];
    cardImageViewGradientLayer.startPoint = CGPointMake(0, 0);
    cardImageViewGradientLayer.endPoint = CGPointMake(0.8, 0);
    self.cardImageView.wantsLayer = YES;
    self.cardImageView.layer.mask = cardImageViewGradientLayer;

    self.cardImageViewGradientLayer = cardImageViewGradientLayer;
    [cardImageViewGradientLayer release];
}

- (void)setAttributes {
    self.manaCostContainerViewWidthConstraint.constant = [self preferredWidthWithManaCostLabel:self.manaCostLabel];
    self.countContainerViewWidthConstraint.constant = [self preferredWidthWithCountLabel:self.countLabel];
    self.cardImageView.postsFrameChangedNotifications = YES;
}

- (void)clearContents {
    self.manaCostLabel.stringValue = @"";
    self.nameLabel.stringValue = @"";
    self.countLabel.stringValue = @"";
    self.imageView.image = nil;
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(cardImageViewDidChangeFrame:)
                                               name:NSViewFrameDidChangeNotification
                                             object:self.cardImageView];
}

- (void)cardImageViewDidChangeFrame:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self updateGradientLayer];
    }];
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.cardImageViewGradientLayer.frame = self.cardImageView.bounds;
    [CATransaction commit];
}

- (CGFloat)preferredWidthWithManaCostLabel:(NSTextField *)manaCostLabel {
    NSString *string = @"99";
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: manaCostLabel.font}
                                       context:nil];
    CGFloat margin = 10;
    CGFloat width = ceilf(rect.size.width + margin);
    
    return width;
}

- (CGFloat)preferredWidthWithCountLabel:(NSTextField *)countLabel {
    NSString *integerString = @"9";
    CGRect integerRect = [integerString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName: countLabel.font}
                                                     context:nil];
    
    NSString *starString = @"★";
    CGRect starRect = [starString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: countLabel.font}
                                               context:nil];
    CGFloat margin = 10;
    CGFloat width = ceilf(MAX(integerRect.size.width, starRect.size.width) + margin);
    
    return width;
}

@end
