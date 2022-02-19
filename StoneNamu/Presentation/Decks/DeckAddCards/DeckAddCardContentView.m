//
//  DeckAddCardContentView.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 8/1/21.
//

#import "DeckAddCardContentView.h"
#import "DeckAddCardContentConfiguration.h"
#import "UIImageView+setAsyncImage.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "InsetsLabel.h"
#import "UIImage+imageWithGrayScale.h"

#define DEGREES_TO_RADIANS(degrees) ((M_PI * degrees) / 180.0f)

@interface DeckAddCardContentView ()
@property (readonly, nonatomic) HSCard * _Nullable hsCard;
@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic) BOOL isLegendary;
@property (retain) InsetsLabel *countLabel;
@end

@implementation DeckAddCardContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {[self configureImageView];
        [self configureCountLabel];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_imageView release];
    [_countLabel release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self drawShapeToCountLabel:self.countLabel];
}

- (void)configureImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [imageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor]
    ]];
    imageView.backgroundColor = UIColor.clearColor;
    
    [self->_imageView release];
    self->_imageView = [imageView retain];
    [imageView release];
}

- (void)configureCountLabel {
    InsetsLabel *countLabel = [InsetsLabel new];
    
    [self addSubview:countLabel];
    
    countLabel.contentInsets = UIEdgeInsetsMake(5, 10, 0, 10);;
    countLabel.layer.masksToBounds = NO;
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.backgroundColor = UIColor.tintColor;
    countLabel.textColor = UIColor.whiteColor;
    countLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [countLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [countLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor],
        [countLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    [self drawShapeToCountLabel:countLabel];
    
    self.countLabel = countLabel;
    [countLabel release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    DeckAddCardContentConfiguration *oldContentConfig = (DeckAddCardContentConfiguration *)self.configuration;
    DeckAddCardContentConfiguration *newContentConfig = [(DeckAddCardContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if (![newContentConfig.hsCard isEqual:oldContentConfig.hsCard]) {
        [self updateImageView];
    } else {
        [self updateGrayScaleToImageView];
    }
    [self updateCountLabel];
    
    [oldContentConfig release];
}

- (void)updateImageView {
    [self.imageView setAsyncImageWithURL:self.hsCard.image indicator:YES completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self updateGrayScaleToImageView];
        }];
    }];
    self.imageView.hidden = NO;
}

- (void)updateGrayScaleToImageView {
    BOOL shouldApplyGrayScale;
    
    if ((self.isLegendary) && (self.count == HSDECK_MAX_SINGLE_LEGENDARY_CARD)) {
        shouldApplyGrayScale = YES;
    } else if (self.count == HSDECK_MAX_SINGLE_CARD) {
        shouldApplyGrayScale = YES;
    } else {
        shouldApplyGrayScale = NO;
    }
    
    if (shouldApplyGrayScale) {
        if (self.imageView.image.isGrayScaleApplied) return;
        
        UIImage *newImage = [self.imageView.image imageWithGrayScale];
        self.imageView.image = newImage;
    } else {
        if (self.imageView.image.imageBeforeGrayScale) {
            self.imageView.image = self.imageView.image.imageBeforeGrayScale;
        } else {
            
        }
    }
}

- (void)updateCountLabel {
    NSUInteger count = self.count;
    int maxCount;
    
    if (self.isLegendary) {
        maxCount = HSDECK_MAX_SINGLE_LEGENDARY_CARD;
    } else {
        maxCount = HSDECK_MAX_SINGLE_CARD;
    }
    
    //
    
    if (count > 0) {
        self.countLabel.alpha = 1.0f;
    } else {
        self.countLabel.alpha = 0.0f;
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu / %d", count, maxCount];
    
    [self drawShapeToCountLabel:self.countLabel];
}

- (void)drawShapeToCountLabel:(InsetsLabel *)countLabel {
    // https://developer.apple.com/library/archive/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/BezierPaths/BezierPaths.html
    CGSize size = countLabel.bounds.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat arrowHeight = countLabel.contentInsets.top;
    CGFloat arrowSideLength = arrowHeight * (1.0f / cos(DEGREES_TO_RADIANS(30.0f)));
    CGFloat radius = (size.height - arrowHeight) / 2.0f;
    CGPoint leftCenter = CGPointMake(radius, size.height - radius);
    CGPoint rightCenter = CGPointMake(size.width - radius, leftCenter.y);
    
    [path moveToPoint:CGPointMake(leftCenter.x,
                                  leftCenter.y - radius)];
    [path addLineToPoint:CGPointMake((size.width - arrowSideLength) / 2.0f,
                                     leftCenter.y - radius)];
    [path addLineToPoint:CGPointMake(size.width / 2.0f,
                                     0.0f)];
    [path addLineToPoint:CGPointMake((size.width + arrowSideLength) / 2.0f,
                                     rightCenter.y - radius)];
    [path addLineToPoint:CGPointMake(rightCenter.x,
                                     rightCenter.y - radius)];
    
    [path addArcWithCenter:rightCenter
                    radius:radius
                startAngle:DEGREES_TO_RADIANS(270.0f)
                  endAngle:DEGREES_TO_RADIANS(0.0f)
                 clockwise:YES];
    
    [path addArcWithCenter:rightCenter
                    radius:radius
                startAngle:DEGREES_TO_RADIANS(0.0f)
                  endAngle:DEGREES_TO_RADIANS(90.0f)
                 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(rightCenter.x,
                                     rightCenter.y + radius)];
    [path addLineToPoint:CGPointMake(leftCenter.x,
                                     leftCenter.y + radius)];
    
    [path addArcWithCenter:leftCenter
                    radius:radius
                startAngle:DEGREES_TO_RADIANS(90.0f)
                  endAngle:DEGREES_TO_RADIANS(180.0f)
                 clockwise:YES];
    
    [path addArcWithCenter:leftCenter
                    radius:radius
                startAngle:DEGREES_TO_RADIANS(180.0f)
                  endAngle:DEGREES_TO_RADIANS(270.0f)
                 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(leftCenter.x,
                                     leftCenter.y - radius)];
    
    //
    
    [path closePath];
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.path = path.CGPath;
    
    countLabel.layer.mask = mask;
    [mask release];
}

- (HSCard * _Nullable)hsCard {
    if (![self.configuration isKindOfClass:[DeckAddCardContentConfiguration class]]) {
        return nil;
    }
    
    DeckAddCardContentConfiguration *contentConfiguration = (DeckAddCardContentConfiguration *)self.configuration;
    return contentConfiguration.hsCard;
}

- (NSUInteger)count {
    if (![self.configuration isKindOfClass:[DeckAddCardContentConfiguration class]]) {
        return 0;
    }
    
    DeckAddCardContentConfiguration *contentConfiguration = (DeckAddCardContentConfiguration *)self.configuration;
    return contentConfiguration.count;
}

- (BOOL)isLegendary {
    if (![self.configuration isKindOfClass:[DeckAddCardContentConfiguration class]]) {
        return NO;
    }
    
    DeckAddCardContentConfiguration *contentConfiguration = (DeckAddCardContentConfiguration *)self.configuration;
    return contentConfiguration.isLegendary;
}

@end
