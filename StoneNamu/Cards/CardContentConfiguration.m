//
//  CardContentConfiguration.m
//  CardContentConfiguration
//
//  Created by Jinwoo Kim on 8/1/21.
//

#import "CardContentConfiguration.h"
#import "CardView.h"

@interface CardContentConfiguration ()
@end

@implementation CardContentConfiguration

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    id copy = [[self class] new];
    
    if (copy) {
        CardContentConfiguration *_copy = (CardContentConfiguration *)copy;
        _copy->_hsCard = [self->_hsCard copyWithZone:zone];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    CardView *cardView = [[CardView new] autorelease];
    cardView.configuration = self;
    return cardView;
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
