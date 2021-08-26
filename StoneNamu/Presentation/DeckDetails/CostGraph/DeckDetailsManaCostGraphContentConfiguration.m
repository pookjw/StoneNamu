//
//  DeckDetailsManaCostGraphContentConfiguration.m
//  DeckDetailsManaCostGraphContentConfiguration
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckDetailsManaCostGraphContentConfiguration.h"
#import "DeckDetailsManaCostGraphContentView.h"

@implementation DeckDetailsManaCostGraphContentConfiguration

- (instancetype)initWithCost:(NSNumber *)cost percentage:(NSNumber *)percentage {
    self = [self init];
    
    if (self) {
        self->_cardManaCost = [cost copy];
        self->_percentage = [percentage copy];
        self->_isDarkMode = NO;
    }
    
    return self;
}

- (void)dealloc {
    [_cardManaCost release];
    [_percentage release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    id copy = [[self class] new];
    
    if (copy) {
        DeckDetailsManaCostGraphContentConfiguration *_copy = (DeckDetailsManaCostGraphContentConfiguration *)copy;
        _copy->_cardManaCost = [self.cardManaCost copy];
        _copy->_percentage = [self.percentage copy];
        _copy->_isDarkMode = self.isDarkMode;
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView { 
    DeckDetailsManaCostGraphContentView *contentView = [DeckDetailsManaCostGraphContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    self->_isDarkMode = (state.traitCollection.userInterfaceStyle != UIUserInterfaceStyleLight);
    return self;
}

@end
