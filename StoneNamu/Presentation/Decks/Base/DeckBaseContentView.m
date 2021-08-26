//
//  DeckBaseContentView.m
//  DeckBaseContentView
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckBaseContentView.h"
#import "DeckBaseContentConfiguration.h"
#import "InsetsLabel.h"
#import "DeckBaseContentViewModel.h"

#define IS_SHADOW_ENABLED_BASE_VIEW 0

@interface DeckBaseContentView ()
@property (retain) InsetsLabel *nameLabel;
@property (retain) UIImageView *imageView;
@property (retain) CAGradientLayer *imageViewGradientLayer;
@property (readonly, nonatomic) LocalDeck * _Nullable localDeck;
@property (retain) DeckBaseContentViewModel *viewModel;
@end

@implementation DeckBaseContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureNameLabel];
        [self configureImageView];
        [self configureViewModel];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_nameLabel release];
    [_imageView release];
    [_imageViewGradientLayer release];
    [_viewModel release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateGradientLayer];
}

- (void)configureNameLabel {
    InsetsLabel *nameLabel = [InsetsLabel new];
    self.nameLabel = nameLabel;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    nameLabel.contentInsets = contentInsets;
    nameLabel.backgroundColor = UIColor.clearColor;
    nameLabel.textColor = nil;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    nameLabel.minimumScaleFactor = 0.1;
    
#if IS_SHADOW_ENABLED_BASE_VIEW
    nameLabel.layer.shadowRadius = 2.0;
    nameLabel.layer.shadowOpacity = 1;
    nameLabel.layer.shadowOffset = CGSizeMake(0, 0);
    nameLabel.layer.masksToBounds = YES;
#endif
    
    NSString *string = @"";
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: nameLabel.font}
                                       context:nil];
    
    [self addSubview:nameLabel];
    
    //
    
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [nameLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [nameLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [nameLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [nameLabel.heightAnchor constraintEqualToConstant:rect.size.height + contentInsets.top + contentInsets.bottom]
    ]];
    
    NSLayoutConstraint *bottomLayout = [nameLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    bottomLayout.active = YES;
    
    [nameLabel release];
}

- (void)configureImageView {
    UIImageView *imageView = [UIImageView new];
    self.imageView = imageView;
    
    imageView.backgroundColor = UIColor.clearColor;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:imageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [imageView.centerYAnchor constraintEqualToAnchor:self.nameLabel.centerYAnchor],
        [imageView.heightAnchor constraintEqualToAnchor:self.nameLabel.heightAnchor],
        [imageView.trailingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor]
    ]];
    
    NSLayoutConstraint *aspectLayout = [NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:imageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:243 / 64
                                                                     constant:0];
    aspectLayout.active = YES;
    
    //
    
    [self bringSubviewToFront:self.nameLabel];
    
    //
    
    CAGradientLayer *imageViewGradientLayer = [CAGradientLayer new];
    self.imageViewGradientLayer = imageViewGradientLayer;
    imageViewGradientLayer.colors = @[
        (id)[UIColor.whiteColor colorWithAlphaComponent:0].CGColor,
        (id)UIColor.whiteColor.CGColor
    ];
    imageViewGradientLayer.startPoint = CGPointMake(0, 0);
    imageViewGradientLayer.endPoint = CGPointMake(0.8, 0);
    imageView.layer.mask = imageViewGradientLayer;
    [imageViewGradientLayer release];
    
    //
    
    [imageView release];
}

- (void)configureViewModel {
    DeckBaseContentViewModel *viewModel = [DeckBaseContentViewModel new];
    self.viewModel = viewModel;
    [viewModel release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    DeckBaseContentConfiguration *oldContentConfig = self.configuration;
    DeckBaseContentConfiguration *newContentConfig = [(DeckBaseContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if (![newContentConfig.localDeck isEqual:oldContentConfig.localDeck]) {
        [self updateNameLabel];
        [self updateImageView];
    }
    
    [self updateNameLabelShadowColor];
    
    [oldContentConfig release];
}

- (LocalDeck * _Nullable)localDeck {
    DeckBaseContentConfiguration *contentConfig = (DeckBaseContentConfiguration *)self.configuration;
    
    if (![contentConfig isKindOfClass:[DeckBaseContentConfiguration class]]) {
        return nil;
    }
    
    return contentConfig.localDeck;
}

- (BOOL)isDarkMode {
    DeckBaseContentConfiguration *contentConfiguration = (DeckBaseContentConfiguration *)self.configuration;
    
    if (![self.configuration isKindOfClass:[DeckBaseContentConfiguration class]]) {
        return NO;
    }
    
    return contentConfiguration.isDarkMode;
}

- (void)updateNameLabel {
    self.nameLabel.text = hsCardClassesWithLocalizable()[NSStringFromHSCardClass(self.localDeck.classId.unsignedIntegerValue)];
}

- (void)updateImageView {
    self.imageView.image = [self.viewModel portraitImageOfClassId:self.localDeck.classId.unsignedIntegerValue];
    [self updateGradientLayer];
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.imageViewGradientLayer.frame = self.imageView.bounds;
    [CATransaction commit];
}

- (void)updateNameLabelShadowColor {
#if IS_SHADOW_ENABLED_BASE_VIEW
    self.nameLabel.layer.shadowColor = self.isDarkMode ? UIColor.blackColor.CGColor : UIColor.whiteColor.CGColor;
#endif
}

@end
