//
//  DeckBaseContentConfiguration.m
//  DeckBaseContentConfiguration
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckBaseContentConfiguration.h"
#import "DeckBaseContentView.h"

@implementation DeckBaseContentConfiguration

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck isEasterEgg:(BOOL)isEasterEgg {
    self = [self init];
    
    if (self) {
        [self->_localDeck release];
        self->_localDeck = [localDeck retain];
        self->_isDarkMode = NO;
        self->_isEasterEgg = isEasterEgg;
    }
    
    return self;
}

- (void)dealloc {
    [_localDeck release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckBaseContentConfiguration *_copy = (DeckBaseContentConfiguration *)copy;
        [_copy->_localDeck release];
        _copy->_localDeck = [self.localDeck retain];
        _copy->_isEasterEgg = self.isEasterEgg;
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    DeckBaseContentView *contentView = [DeckBaseContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    self->_isDarkMode = (state.traitCollection.userInterfaceStyle != UIUserInterfaceStyleLight);
    return self;
}

@end
