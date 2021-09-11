//
//  DeckImageRenderServiceCardContentConfiguration.m
//  DeckImageRenderServiceCardContentConfiguration
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import "DeckImageRenderServiceCardContentConfiguration.h"
#import "DeckImageRenderServiceCardContentView.h"

@implementation DeckImageRenderServiceCardContentConfiguration

- (instancetype)initWithHSCard:(HSCard *)hsCard hsCardImage:(UIImage *)hsCardImage hsCardCount:(NSUInteger)hsCardCount {
    self = [self init];
    
    if (self) {
        self->_hsCard = [hsCard copy];
        self->_hsCardImage = [hsCardImage retain];
        self->_hsCardCount = hsCardCount;
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_hsCardImage release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckImageRenderServiceCardContentConfiguration *_copy = (DeckImageRenderServiceCardContentConfiguration *)copy;
        _copy->_hsCard = [self.hsCard copy];
        _copy->_hsCardImage = [self.hsCardImage retain];
        _copy->_hsCardCount = self.hsCardCount;
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
