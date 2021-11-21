//
//  CardDetailsChildrenContentConfiguration.m
//  CardDetailsChildrenContentConfiguration
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import "CardDetailsChildrenContentConfiguration.h"
#import "CardDetailsChildrenContentView.h"

@implementation CardDetailsChildrenContentConfiguration

- (instancetype)initWithChildCards:(NSArray<HSCard *> *)childCards {
    self = [self init];
    
    if (self) {
        [self->_childCards release];
        self->_childCards = [childCards copy];
    }
    
    return self;
}

- (void)dealloc {
    [_childCards release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        CardDetailsChildrenContentConfiguration *_copy = (CardDetailsChildrenContentConfiguration *)copy;
        
        [_copy->_childCards release];
        _copy->_childCards = [self.childCards copyWithZone:zone];
        _copy.delegate = self.delegate;
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    CardDetailsChildrenContentView *contentView = [[CardDetailsChildrenContentView new] autorelease];
    contentView.configuration = self;
    return contentView;
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
