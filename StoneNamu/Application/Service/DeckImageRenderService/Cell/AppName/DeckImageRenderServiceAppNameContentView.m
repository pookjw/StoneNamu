//
//  DeckImageRenderServiceAppNameContentView.m
//  DeckImageRenderServiceAppNameContentView
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "DeckImageRenderServiceAppNameContentView.h"
#import "DeckImageRenderServiceAppNameContentConfiguration.h"
#import "InsetsLabel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckImageRenderServiceAppNameContentView ()
@property (retain) InsetsLabel *appNameLabel;
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
    [_appNameLabel release];
    [super dealloc];
}

- (void)setAttributes {
    self.backgroundColor = UIColor.clearColor;
}

- (void)configureAboutLabel {
    InsetsLabel *aboutLabel = [InsetsLabel new];
    
    aboutLabel.contentInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    aboutLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFBold size:18.0f];
    aboutLabel.backgroundColor = UIColor.clearColor;
    aboutLabel.textColor = UIColor.whiteColor;
    aboutLabel.textAlignment = NSTextAlignmentCenter;
    aboutLabel.text = [ResourcesService localizationForKey:LocalizableKeyAppName];
    
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
    
    self.appNameLabel = aboutLabel;
    [aboutLabel release];
}

@end
