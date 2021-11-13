//
//  DeckImageRenderServiceAppNameContentView.m
//  DeckImageRenderServiceAppNameContentView
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "DeckImageRenderServiceAppNameContentView.h"
#import "DeckImageRenderServiceAppNameContentConfiguration.h"
#import "InsetsLabel.h"
#import "UIFont+customFonts.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckImageRenderServiceAppNameContentView ()
@property (retain) InsetsLabel *aboutLabel;
@end

@implementation DeckImageRenderServiceAppNameContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureAboutLabel];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_aboutLabel release];
    [super dealloc];
}

- (void)setAttributes {
    self.backgroundColor = UIColor.clearColor;
}

- (void)configureAboutLabel {
    InsetsLabel *aboutLabel = [InsetsLabel new];
    self.aboutLabel = aboutLabel;
    
    aboutLabel.contentInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    aboutLabel.font = [UIFont customFontWithType:UIFontCustomFontTypeGmarketSansBold size:18];
    aboutLabel.backgroundColor = UIColor.clearColor;
    aboutLabel.textColor = UIColor.whiteColor;
    aboutLabel.textAlignment = NSTextAlignmentCenter;
    aboutLabel.text = [ResourcesService localizaedStringForKey:LocalizableKeyAppName];
    
    [self addSubview:aboutLabel];
    aboutLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [aboutLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [aboutLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [aboutLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
    ]];
    
    NSLayoutConstraint *bottomLayout = [aboutLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    bottomLayout.active = YES;
    
    [aboutLabel release];
}

@end
