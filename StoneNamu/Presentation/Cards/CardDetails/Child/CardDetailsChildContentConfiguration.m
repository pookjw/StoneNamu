//
//  CardDetailsChildContentConfiguration.m
//  CardDetailsChildContentConfiguration
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import "CardDetailsChildContentConfiguration.h"
#import "CardDetailsChildContentView.h"

@implementation CardDetailsChildContentConfiguration

- (instancetype)initWithHSCard:(HSCard *)hsCard {
    self = [self init];
    
    if (self) {
        [self->_hsCard release];
        self->_hsCard = [hsCard copy];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        CardDetailsChildContentConfiguration *_copy = (CardDetailsChildContentConfiguration *)copy;
        [_copy->_hsCard release];
        _copy->_hsCard = [self.hsCard copyWithZone:zone];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    CardDetailsChildContentView *contentView = [CardDetailsChildContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
