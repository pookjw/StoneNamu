//
//  CardBacksContentConfiguration.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/6/22.
//

#import "CardBacksContentConfiguration.h"
#import "CardBacksContentView.h"

@implementation CardBacksContentConfiguration

- (instancetype)initWithHSCardBack:(HSCardBack *)hsCardBack {
    self = [self init];
    
    if (self) {
        [self->_hsCardBack release];
        self->_hsCardBack = [hsCardBack copy];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCardBack release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        CardBacksContentConfiguration *_copy = (CardBacksContentConfiguration *)copy;
        
        [_copy->_hsCardBack release];
        _copy->_hsCardBack = [self.hsCardBack copyWithZone:zone];
    }
    
    return copy;
}

- (id)makeContentView {
    CardBacksContentView *cardView = [[CardBacksContentView new] autorelease];
    [cardView setConfiguration:self];
    return cardView;
}

- (nonnull instancetype)updatedConfigurationForState:(id)state {
    return self;
}

@end
