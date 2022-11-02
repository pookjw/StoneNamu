//
//  DeckImageRenderServiceCardCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import "DeckImageRenderServiceCardCollectionViewItem.h"
#import "NSTextField+setFontSizeToFitWithMaxFontSize.h"
#import "NSView+setMasksToBounds.h"
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
@property (retain) id<NSObject> observer;
@end

@implementation DeckImageRenderServiceCardCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureManaCostBoxWidthLayout];
    [self configureCountBoxWidthLayout];
    [self configureCardImageViewGradientLayer];
    [self bind];
}

- (void)viewDidLayout {
    [super viewDidLayout];
    [self updateGradientLayer];
    [self.nameLabel setFontSizeToFitWithMaxFontSize:18.0f inWidth:self.view.bounds.size.width - self.manaCostBoxWidthLayout.constant - (10.0f * 2) - self.countBoxWidthLayout.constant];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self.observer];
    [_cardImageView release];
    [_manaCostLabel release];
    [_manaCostBoxWidthLayout release];
    [_nameLabel release];
    [_countLabel release];
    [_countBoxWidthLayout release];
    [_cardImageViewGradientLayer release];
    [_observer release];
    [super dealloc];
}

- (void)configureWithHSCard:(HSCard *)hsCard hsCardImage:(NSImage *)haCardImage raritySlug:(HSCardRaritySlugType)raritySlug hsCardCount:(NSUInteger)hsCardCount {
    self.cardImageView.image = haCardImage;
    self.nameLabel.stringValue = hsCard.name;
    
    if ([raritySlug isEqualToString:HSCardRaritySlugTypeCommon]) {
        self.nameLabel.textColor = NSColor.whiteColor;
    } else if ([raritySlug isEqualToString:HSCardRaritySlugTypeRare]) {
        self.nameLabel.textColor = NSColor.cyanColor;
    } else if ([raritySlug isEqualToString:HSCardRaritySlugTypeEpic]) {
        self.nameLabel.textColor = NSColor.magentaColor;
    } else if ([raritySlug isEqualToString:HSCardRaritySlugTypeLegendary]) {
        self.nameLabel.textColor = NSColor.orangeColor;
    } else {
        self.nameLabel.textColor = NSColor.grayColor;
    }
    
    self.manaCostLabel.stringValue = [NSString stringWithFormat:@"%lu", hsCard.manaCost];
    
    if (([raritySlug isEqualToString:HSCardRaritySlugTypeLegendary]) && (hsCardCount == 1)) {
        self.countLabel.stringValue = @"★";
    } else {
        self.countLabel.stringValue = [NSString stringWithFormat:@"%lu", hsCardCount];
    }
}

- (void)setAttributes {
    self.cardImageView.wantsLayer = YES;
    self.cardImageView.postsFrameChangedNotifications = YES;
    
    self.manaCostLabel.wantsLayer = YES;
    self.manaCostLabel.layer.masksToBounds = NO;
    
    self.countLabel.wantsLayer = YES;
    self.countLabel.layer.masksToBounds = NO;
    
    self.nameLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFMedium size:18.0f];
    self.manaCostLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFBold size:18.0f];
    self.countLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFBold size:18.0f];
    self.nameLabel.wantsLayer = YES;
    self.nameLabel.layer.shadowRadius = 2.0;
    self.nameLabel.layer.shadowOpacity = 1;
    self.nameLabel.layer.shadowOffset = CGSizeZero;
    self.nameLabel.layer.shadowColor = NSColor.blackColor.CGColor;
    self.nameLabel.layer.masksToBounds = NO;
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
        (id)NSColor.clearColor.CGColor,
        (id)NSColor.whiteColor.CGColor
    ];
    cardImageViewGradientLayer.startPoint = CGPointMake(0.3f, 0.0f);
    cardImageViewGradientLayer.endPoint = CGPointMake(1.0f, 0.0f);
    self.cardImageView.layer.mask = cardImageViewGradientLayer;
    self.cardImageViewGradientLayer = cardImageViewGradientLayer;
    [cardImageViewGradientLayer release];
}

- (void)bind {
    self.observer = [NSNotificationCenter.defaultCenter addObserverForName:NSViewFrameDidChangeNotification
                                                                    object:self.cardImageView
                                                                     queue:NSOperationQueue.mainQueue
                                                                usingBlock:^(NSNotification * _Nonnull note) {
        [self updateGradientLayer];
    }];
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.cardImageViewGradientLayer.frame = self.cardImageView.bounds;
    [CATransaction commit];
}

@end
