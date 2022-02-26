//
//  CardContentConfiguration.m
//  CardContentConfiguration
//
//  Created by Jinwoo Kim on 8/1/21.
//

#import "CardContentConfiguration.h"
#import "CardContentView.h"

@interface CardContentConfiguration ()
@end

@implementation CardContentConfiguration

- (instancetype)initWithHSCard:(HSCard *)hsCard hsCardGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType {
    self = [self init];
    
    if (self) {
        [self->_hsCard release];
        self->_hsCard = [hsCard copy];
        
        [self->_hsCardGameModeSlugType release];
        self->_hsCardGameModeSlugType = [hsCardGameModeSlugType copy];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_hsCardGameModeSlugType release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    id copy = [[self class] new];
    
    if (copy) {
        CardContentConfiguration *_copy = (CardContentConfiguration *)copy;
        
        [_copy->_hsCard release];
        _copy->_hsCard = [self.hsCard copyWithZone:zone];
        
        [_copy->_hsCardGameModeSlugType release];
        _copy->_hsCardGameModeSlugType = [self.hsCardGameModeSlugType copyWithZone:zone];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    CardContentView *cardView = [[CardContentView new] autorelease];
    cardView.configuration = self;
    return cardView;
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
