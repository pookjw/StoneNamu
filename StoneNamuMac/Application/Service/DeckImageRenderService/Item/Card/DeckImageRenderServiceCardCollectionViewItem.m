//
//  DeckImageRenderServiceCardCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import "DeckImageRenderServiceCardCollectionViewItem.h"
#import "NSTextField+setFontSizeToFitWithMaxFontSize.h"
#import <QuartzCore/QuartzCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckImageRenderServiceCardCollectionViewItem ()
@property (retain) IBOutlet NSImageView *cardImageView;
@property (retain) IBOutlet NSTextField *manaCostLabel;
@property (retain) IBOutlet NSLayoutConstraint *manaCostBoxWidthLayout;
@property (retain) IBOutlet NSTextField *nameLabel;
@property (retain) IBOutlet NSTextField *countLabel;
@property (retain) IBOutlet NSLayoutConstraint *countBoxWidthLayout;
@property (retain) CAGradientLayer *cardImageViewGradientLayer;
@end

@implementation DeckImageRenderServiceCardCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureManaCostBoxWidthLayout];
    [self configureCountBoxWidthLayout];
    [self configureCardImageViewGradientLayer];
    [self configureNameLabelLayer];
}

- (void)viewDidLayout {
    [super viewDidLayout];
    [self updateGradientLayer];
    [self.nameLabel setFontSizeToFitWithMaxFontSize:18.0f inWidth:self.view.bounds.size.width - self.manaCostBoxWidthLayout.constant - (10.0f * 2) - self.countBoxWidthLayout.constant];
}

- (void)dealloc {
    [_cardImageView release];
    [_manaCostLabel release];
    [_manaCostBoxWidthLayout release];
    [_nameLabel release];
    [_countLabel release];
    [_countBoxWidthLayout release];
    [_cardImageViewGradientLayer release];
    [super dealloc];
}

- (void)configureWithHSCard:(HSCard *)hsCard hsCardImage:(NSImage *)haCardImage hsCardCount:(NSUInteger)hsCardCount {
    self.cardImageView.image = haCardImage;
    self.nameLabel.stringValue = hsCard.name;
    
    switch (hsCard.rarityId) {
        case HSCardRarityCommon:
            self.nameLabel.textColor = NSColor.whiteColor;
            break;
        case HSCardRarityRare:
            self.nameLabel.textColor = NSColor.cyanColor;
            break;
        case HSCardRarityEpic:
            self.nameLabel.textColor = NSColor.magentaColor;
            break;
        case HSCardRarityLegendary:
            self.nameLabel.textColor = NSColor.orangeColor;
            break;
        default:
            self.nameLabel.textColor = NSColor.grayColor;
            break;
    }
    
    self.manaCostLabel.stringValue = [NSString stringWithFormat:@"%lu", hsCard.manaCost];
    
    if ((hsCard.rarityId == HSCardRarityLegendary) && (hsCardCount == 1)) {
        self.countLabel.stringValue = @"★";
    } else {
        self.countLabel.stringValue = [NSString stringWithFormat:@"%lu", hsCardCount];
    }
}

- (void)setAttributes {
    self.nameLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFMedium size:18.0f];
    self.manaCostLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFBold size:18.0f];
    self.countLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFBold size:18.0f];
}

- (void)configureManaCostBoxWidthLayout {
    NSString *string = @"99";
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: self.manaCostLabel.font}
                                       context:nil];
    CGFloat margin = 10;
    CGFloat width = ceilf(rect.size.width + margin);
    
    self.manaCostBoxWidthLayout.constant = width;
}

- (void)configureCountBoxWidthLayout {
    NSString *integerString = @"9";
    CGRect integerRect = [integerString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName: self.countLabel.font}
                                                     context:nil];
    
    NSString *starString = @"★";
    CGRect starRect = [starString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: self.countLabel.font}
                                               context:nil];
    CGFloat margin = 10;
    CGFloat width = ceilf(MAX(integerRect.size.width, starRect.size.width) + margin);
    
    self.countBoxWidthLayout.constant = width;
}

- (void)configureCardImageViewGradientLayer {
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

- (void)configureNameLabelLayer {
    self.nameLabel.wantsLayer = YES;
    self.nameLabel.layer.shadowRadius = 2.0;
    self.nameLabel.layer.shadowOpacity = 1;
    self.nameLabel.layer.shadowOffset = CGSizeZero;
    self.nameLabel.layer.shadowColor = NSColor.blackColor.CGColor;
    self.nameLabel.layer.masksToBounds = NO;
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.cardImageViewGradientLayer.frame = self.cardImageView.bounds;
    [CATransaction commit];
}

@end
