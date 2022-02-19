//
//  DeckImageRenderServiceIntroContentConfiguration.m
//  DeckImageRenderServiceIntroContentConfiguration
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "DeckImageRenderServiceIntroContentConfiguration.h"
#import "DeckImageRenderServiceIntroContentView.h"

@implementation DeckImageRenderServiceIntroContentConfiguration

- (instancetype)initWithClassSlug:(NSString *)classSlug className:(NSString *)className deckName:(NSString *)deckName deckFormat:(HSDeckFormat)deckFormat isEasterEgg:(BOOL)isEasterEgg {
    self = [self init];
    
    if (self) {
        [self->_classSlug release];
        self->_classSlug = [classSlug copy];
        
        [self->_className release];
        self->_className = [className copy];
        
        [self->_deckName release];
        self->_deckName = [deckName copy];
        
        [self->_deckFormat release];
        self->_deckFormat = [deckFormat copy];
        
        self->_isEasterEgg = isEasterEgg;
    }
    
    return self;
}

- (void)dealloc {
    [_classSlug release];
    [_className release];
    [_deckName release];
    [_deckFormat release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckImageRenderServiceIntroContentConfiguration *_copy = (DeckImageRenderServiceIntroContentConfiguration *)copy;
        
        [_copy->_classSlug release];
        _copy->_classSlug = [self.classSlug copyWithZone:zone];
        
        [_copy->_className release];
        _copy->_className = [self.className copyWithZone:zone];
        
        [_copy->_deckName release];
        _copy->_deckName = [self.deckName copyWithZone:zone];
        
        [_copy->_deckFormat release];
        _copy->_deckFormat = [self.deckFormat copyWithZone:zone];
        
        _copy->_isEasterEgg = self.isEasterEgg;
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    DeckImageRenderServiceIntroContentView *contentView = [DeckImageRenderServiceIntroContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
