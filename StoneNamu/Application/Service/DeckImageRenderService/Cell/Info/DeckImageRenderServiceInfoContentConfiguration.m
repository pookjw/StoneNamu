//
//  DeckImageRenderServiceInfoContentConfiguration.m
//  DeckImageRenderServiceInfoContentConfiguration
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "DeckImageRenderServiceInfoContentConfiguration.h"
#import "DeckImageRenderServiceInfoContentView.h"

@implementation DeckImageRenderServiceInfoContentConfiguration

- (instancetype)initWithHSYearCurrent:(NSString *)hsYearCurrent deckFormat:(HSDeckFormat)deckFormat {
    self = [self init];
    
    if (self) {
        self->_hsYearCurrent = [hsYearCurrent copy];
        self->_deckFormat = [deckFormat copy];
    }
    
    return self;
}

- (void)dealloc {
    [_hsYearCurrent release];
    [_deckFormat release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckImageRenderServiceInfoContentConfiguration *_copy = (DeckImageRenderServiceInfoContentConfiguration *)copy;
        _copy->_hsYearCurrent = [self.hsYearCurrent copy];
        _copy->_deckFormat = [self.deckFormat copy];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    DeckImageRenderServiceInfoContentView *contentView = [DeckImageRenderServiceInfoContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
