//
//  CardDetailsChildrenContentImageConfiguration.m
//  CardDetailsChildrenContentImageConfiguration
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import "CardDetailsChildrenContentImageConfiguration.h"
#import "CardDetailsChildrenContentImageContentView.h"

@implementation CardDetailsChildrenContentImageConfiguration

- (instancetype)initWithHSCard:(HSCard *)hsCard {
    self = [self init];
    
    if (self) {
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
        CardDetailsChildrenContentImageConfiguration *_copy = (CardDetailsChildrenContentImageConfiguration *)copy;
        _copy->_hsCard = [self.hsCard copy];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    CardDetailsChildrenContentImageContentView *contentView = [CardDetailsChildrenContentImageContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
