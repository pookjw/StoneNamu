//
//  CardContentView.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 8/1/21.
//

#import "CardContentView.h"
#import "CardContentConfiguration.h"

@interface CardContentView ()
@property (retain) UILabel *label;
@end

@implementation CardContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        UILabel *label = [UILabel new];
        self.label = label;
        [self addSubview:label];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [label.topAnchor constraintEqualToAnchor:self.topAnchor],
            [label.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
        label.font = [UIFont systemFontOfSize:50];
        [label release];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_label release];
    [super dealloc];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self->configuration release];
    CardContentConfiguration *cardContent = (CardContentConfiguration *)configuration;
    self->configuration = [cardContent copy];
    [self updateWithText:cardContent.hsCard.name];
}

- (void)updateWithText:(NSString *)text {
    self.label.text = text;
}

@end
