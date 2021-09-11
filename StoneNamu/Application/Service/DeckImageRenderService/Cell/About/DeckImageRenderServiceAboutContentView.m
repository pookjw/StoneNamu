//
//  DeckImageRenderServiceAboutContentView.m
//  DeckImageRenderServiceAboutContentView
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "DeckImageRenderServiceAboutContentView.h"
#import "DeckImageRenderServiceAboutContentConfiguration.h"
#import "InsetsLabel.h"

@interface DeckImageRenderServiceAboutContentView ()
@property (retain) InsetsLabel *aboutLabel;
@end

@implementation DeckImageRenderServiceAboutContentView

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
    
    aboutLabel.contentInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    aboutLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    aboutLabel.backgroundColor = UIColor.clearColor;
    aboutLabel.textColor = UIColor.whiteColor;
    aboutLabel.textAlignment = NSTextAlignmentCenter;
    aboutLabel.text = NSLocalizedString(@"APP_NAME", @"");
    
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
