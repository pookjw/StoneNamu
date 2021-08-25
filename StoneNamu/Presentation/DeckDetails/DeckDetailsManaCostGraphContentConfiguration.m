//
//  DeckDetailsManaCostGraphContentConfiguration.m
//  DeckDetailsManaCostGraphContentConfiguration
//
//  Created by Jinwoo Kim on 8/24/21.
//

#import "DeckDetailsManaCostGraphContentConfiguration.h"
#import "DeckDetailsManaCostGraphContentView.h"

@implementation DeckDetailsManaCostGraphContentConfiguration

- (instancetype)initWithManaDictionary:(NSDictionary<NSNumber *,NSNumber *> *)manaDictionary {
    self = [self init];
    
    if (self) {
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
        DeckDetailsManaCostGraphContentConfiguration *_copy = (DeckDetailsManaCostGraphContentConfiguration *)copy;
        _copy->_manaDictionary = [self.manaDictionary copyWithZone:zone];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    DeckDetailsManaCostGraphContentView *contentView = [DeckDetailsManaCostGraphContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
