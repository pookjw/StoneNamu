//
//  DeckAddCardContentConfiguration.m
//  DeckAddCardContentConfiguration
//
//  Created by Jinwoo Kim on 8/1/21.
//

#import "DeckAddCardContentConfiguration.h"
#import "DeckAddCardContentView.h"

@interface DeckAddCardContentConfiguration ()
@end

@implementation DeckAddCardContentConfiguration

- (instancetype)initWithHSCard:(HSCard *)hsCard count:(NSUInteger)count isLegendary:(BOOL)isLegendary {
    self = [self init];
    
    if (self) {
        [self->_hsCard release];
        self->_hsCard = [hsCard copy];
        
        self->_count = count;
        
        self->_isLegendary = isLegendary;
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    id copy = [[self class] new];
    
    if (copy) {
        DeckAddCardContentConfiguration *_copy = (DeckAddCardContentConfiguration *)copy;
        
        [_copy->_hsCard release];
        _copy->_hsCard = [self.hsCard copyWithZone:zone];
        
        _copy->_count = self.count;
        _copy->_isLegendary = self.isLegendary;
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    DeckAddCardContentView *cardView = [[DeckAddCardContentView new] autorelease];
    cardView.configuration = self;
    return cardView;
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
