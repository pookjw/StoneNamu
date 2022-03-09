//
//  CardDetailsBasicContentConfiguration.m
//  CardDetailsBasicContentConfiguration
//
//  Created by Jinwoo Kim on 8/6/21.
//

#import "CardDetailsBasicContentConfiguration.h"
#import "CardDetailsBasicContentView.h"

@implementation CardDetailsBasicContentConfiguration

- (__kindof UIView<UIContentView> *)makeContentView {
    CardDetailsBasicContentView *contentView = [[CardDetailsBasicContentView alloc] initWithConfiguration:self];
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
