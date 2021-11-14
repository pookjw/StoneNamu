//
//  DeckDetailsManaCostContentConfiguration.m
//  DeckDetailsManaCostContentConfiguration
//
//  Created by Jinwoo Kim on 8/24/21.
//

#import "DeckDetailsManaCostContentConfiguration.h"
#import "DeckDetailsManaCostContentView.h"

@implementation DeckDetailsManaCostContentConfiguration

- (instancetype)initWithManaDictionary:(NSDictionary<NSNumber *,NSNumber *> *)manaDictionary {
    self = [self init];
    
    if (self) {
        [self->_manaDictionary release];
        self->_manaDictionary = [manaDictionary copy];
    }
    
    return self;
}

- (void)dealloc {
    [_manaDictionary release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckDetailsManaCostContentConfiguration *_copy = (DeckDetailsManaCostContentConfiguration *)copy;
        [_copy->_manaDictionary release];
        _copy->_manaDictionary = [self.manaDictionary copyWithZone:zone];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    DeckDetailsManaCostContentView *contentView = [DeckDetailsManaCostContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
