//
//  PickerItemView.m
//  PickerItemView
//
//  Created by Jinwoo Kim on 7/26/21.
//

#import "PickerItemView.h"

@interface PickerItemView ()
@property UIImageView *imageView;
@property (retain) NSLayoutConstraint *imageViewAspectLayout;
@property (retain) NSLayoutConstraint *imageViewWidthLayout;
@property UIStackView *stackView;
@property UILabel *primaryLabel;
@property UILabel *secondaryLabel;
@end

@implementation PickerItemView

+ (CGFloat)getHeightUsingWidth:(CGFloat)width {
    NSString *string = @"a";
    
    CGRect rect1 = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3]}
                                        context:nil];
    CGRect rect2 = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}
                                        context:nil];
    
    CGFloat height1 = rect1.size.height;
    CGFloat height2 = rect2.size.height;
    CGFloat margin = 50;
    
    return height1 + height2 + margin;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureViews];
    }
    
    return self;
}

- (void)dealloc {
    [_imageViewAspectLayout release];
    [_imageViewWidthLayout release];
    [super dealloc];
}

- (void)configureViews {
    UIImageView *imageView = [UIImageView new];
    self.imageView = imageView;
    [self addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [imageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    NSLayoutConstraint *imageViewWidthLayout = [imageView.widthAnchor constraintEqualToConstant:0];
    self.imageViewWidthLayout = imageViewWidthLayout;
    imageViewWidthLayout.priority = 999;
    NSLayoutConstraint *imageViewAspectLayout = [NSLayoutConstraint constraintWithItem:imageView
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:imageView
                                                                             attribute:NSLayoutAttributeWidth
                                                                            multiplier:1
                                                                              constant:0];
    self.imageViewAspectLayout = imageViewAspectLayout;
    
    UIStackView *stackView = [UIStackView new];
    self.stackView = stackView;
    [self addSubview:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    
    UILabel *primaryLabel = [UILabel new];
    self.primaryLabel = primaryLabel;
    [stackView addArrangedSubview:primaryLabel];
    primaryLabel.adjustsFontForContentSizeCategory = YES;
    primaryLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    primaryLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *secondaryLabel = [UILabel new];
    self.secondaryLabel = secondaryLabel;
    [stackView addArrangedSubview:secondaryLabel];
    secondaryLabel.adjustsFontForContentSizeCategory = YES;
    secondaryLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    secondaryLabel.textAlignment = NSTextAlignmentCenter;
    
    [imageView release];
    [stackView release];
    [primaryLabel release];
    [secondaryLabel release];
}

- (void)configureWithImage:(UIImage * _Nullable)image primaryText:(NSString *)primaryText secondaryText:(NSString * _Nullable)secondaryText {
    self.imageView.image = image;
    self.primaryLabel.text = primaryText;
    self.secondaryLabel.text = secondaryText;
    
    if (image) {
        [self.imageViewAspectLayout setActive:YES];
        [self.imageViewWidthLayout setActive:NO];
    } else {
        [self.imageViewAspectLayout setActive:NO];
        [self.imageViewWidthLayout setActive:YES];
    }
    
    if (secondaryText) {
        self.secondaryLabel.hidden = NO;
    } else {
        self.secondaryLabel.hidden = YES;
    }
}

@end
