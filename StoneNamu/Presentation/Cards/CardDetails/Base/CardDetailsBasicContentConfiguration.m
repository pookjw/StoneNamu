//
//  CardDetailsBasicContentConfiguration.m
//  CardDetailsBasicContentConfiguration
//
//  Created by Jinwoo Kim on 8/6/21.
//

#import "CardDetailsBasicContentConfiguration.h"
#import "CardDetailsBasicContentView.h"

@implementation CardDetailsBasicContentConfiguration

- (instancetype)initWithLeadingText:(NSString *)leadingText trailingText:(NSString *)trailingText {
    self = [self init];
    
    if (self) {
        [self->_leadingText release];
        self->_leadingText = [leadingText copy];
        [self->_trailingText release];
        self->_trailingText = [trailingText copy];
    }
    
    return self;
}

- (void)dealloc {
    [_leadingText release];
    [_trailingText release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        CardDetailsBasicContentConfiguration *_copy = (CardDetailsBasicContentConfiguration *)copy;
        
        [_copy->_leadingText release];
        _copy->_leadingText = [self.leadingText copyWithZone:zone];
        [_copy->_trailingText release];
        _copy->_trailingText = [self.trailingText copyWithZone:zone];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    CardDetailsBasicContentView *contentView = [[CardDetailsBasicContentView new] autorelease];
    contentView.configuration = self;
    return contentView;
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
