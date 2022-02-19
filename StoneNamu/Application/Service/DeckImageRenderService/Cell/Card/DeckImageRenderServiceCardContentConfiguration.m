//
//  DeckImageRenderServiceCardContentConfiguration.m
//  DeckImageRenderServiceCardContentConfiguration
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import "DeckImageRenderServiceCardContentConfiguration.h"
#import "DeckImageRenderServiceCardContentView.h"

@implementation DeckImageRenderServiceCardContentConfiguration

- (instancetype)initWithHSCard:(HSCard *)hsCard hsCardImage:(UIImage *)hsCardImage hsCardCount:(NSUInteger)hsCardCount raritySlug:(HSCardRaritySlugType)raritySlug {
    self = [self init];
    
    if (self) {
        [self->_hsCard release];
        self->_hsCard = [hsCard copy];
        
        [self->_hsCardImage release];
        self->_hsCardImage = [hsCardImage retain];
        
        self->_hsCardCount = hsCardCount;
        
        [self->_raritySlug release];
        self->_raritySlug = [raritySlug copy];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_hsCardImage release];
    [_raritySlug release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckImageRenderServiceCardContentConfiguration *_copy = (DeckImageRenderServiceCardContentConfiguration *)copy;
        [_copy->_hsCard release];
        _copy->_hsCard = [self.hsCard copyWithZone:zone];
        
        [_copy->_hsCardImage release];
        _copy->_hsCardImage = [self.hsCardImage retain];
        
        _copy->_hsCardCount = self.hsCardCount;
        
        [_copy->_raritySlug release];
        _copy->_raritySlug = [self.raritySlug copyWithZone:zone];
    }
    
    return copy;
}

- (__kindof UIView<UIContentView> *)makeContentView {
    DeckImageRenderServiceCardContentView *contentView = [DeckImageRenderServiceCardContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (instancetype)updatedConfigurationForState:(id<UIConfigurationState>)state {
    return self;
}

@end
