//
//  DeckBaseContentConfiguration.m
//  DeckBaseContentConfiguration
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckBaseContentConfiguration.h"
#import "DeckBaseContentView.h"

@implementation DeckBaseContentConfiguration

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck classSlug:(NSString *)classSlug isEasterEgg:(BOOL)isEasterEgg count:(NSUInteger)count {
    self = [self init];
    
    if (self) {
        [self->_localDeck release];
        self->_localDeck = [localDeck retain];
        
        [self->_classSlug release];
        self->_classSlug = [classSlug copy];
        
        self->_isDarkMode = NO;
        self->_isEasterEgg = isEasterEgg;
        self->_count = count;
    }
    
    return self;
}

- (void)dealloc {
    [_localDeck release];
    [_classSlug release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckBaseContentConfiguration *_copy = (DeckBaseContentConfiguration *)copy;
        [_copy->_localDeck release];
        _copy->_localDeck = [self.localDeck retain];
        
        [_copy->_classSlug release];
        _copy->_classSlug = [self.classSlug copyWithZone:zone];
        
        _copy->_isEasterEgg = self.isEasterEgg;
        _copy->_count = self.count;
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
