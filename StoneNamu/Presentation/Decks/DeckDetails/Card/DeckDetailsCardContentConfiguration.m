//
//  DeckDetailsCardContentConfiguration.m
//  DeckDetailsCardContentConfiguration
//
//  Created by Jinwoo Kim on 8/23/21.
//

#import "DeckDetailsCardContentConfiguration.h"
#import "DeckDetailsCardContentView.h"

@implementation DeckDetailsCardContentConfiguration

- (instancetype)initWithHSCard:(HSCard *)hsCard hsCardCount:(NSUInteger)count raritySlugType:(HSCardRaritySlugType)raritySlugType {
    self = [self init];
    
    if (self) {
        [self->_hsCard release];
        self->_hsCard = [hsCard copy];
        
        self->_hsCardCount = count;
        self->_isDarkMode = NO;
        
        [self->_raritySlugType release];
        self->_raritySlugType = [raritySlugType copy];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_raritySlugType release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    id copy = [[self class] new];
    
    if (copy) {
        DeckDetailsCardContentConfiguration *_copy = (DeckDetailsCardContentConfiguration *)copy;
        [_copy->_hsCard release];
        _copy->_hsCard = [self.hsCard copyWithZone:zone];
        
        _copy->_hsCardCount = self.hsCardCount;
        _copy->_isDarkMode = self.isDarkMode;
        
        [_copy->_raritySlugType release];
        _copy->_raritySlugType = [self.raritySlugType copyWithZone:zone];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView { 
    DeckDetailsCardContentView *contentView = [DeckDetailsCardContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    self->_isDarkMode = (state.traitCollection.userInterfaceStyle != UIUserInterfaceStyleLight);
    return self;
}

@end
