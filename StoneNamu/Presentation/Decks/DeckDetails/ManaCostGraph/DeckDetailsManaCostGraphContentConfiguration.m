//
//  DeckDetailsManaCostGraphContentConfiguration.m
//  DeckDetailsManaCostGraphContentConfiguration
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckDetailsManaCostGraphContentConfiguration.h"
#import "DeckDetailsManaCostGraphContentView.h"

@implementation DeckDetailsManaCostGraphContentConfiguration

- (instancetype)initWithCost:(NSUInteger)cardManaCost percentage:(float)percentage cardCount:(NSUInteger)cardCount {
    self = [self init];
    
    if (self) {
        self->_cardManaCost = cardManaCost;
        self->_percentage = percentage;
        self->_cardCount = cardCount;
        self->_isDarkMode = NO;
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    id copy = [[self class] new];
    
    if (copy) {
        DeckDetailsManaCostGraphContentConfiguration *_copy = (DeckDetailsManaCostGraphContentConfiguration *)copy;
        _copy->_cardManaCost = self.cardManaCost;
        _copy->_percentage = self.percentage;
        _copy->_cardCount = self.cardCount;
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
