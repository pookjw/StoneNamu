//
//  DeckImageRenderServiceAboutContentConfiguration.m
//  DeckImageRenderServiceAboutContentConfiguration
//
//  Created by Jinwoo Kim on 9/15/21.
//

#import "DeckImageRenderServiceAboutContentConfiguration.h"
#import "DeckImageRenderServiceAboutContentView.h"

@implementation DeckImageRenderServiceAboutContentConfiguration

- (instancetype)initWithTotalArcaneDust:(NSNumber *)totalArcaneDust hsYearCurrent:(NSString *)hsYearCurrent {
    self = [self init];
    
    if (self) {
        self->_totalArcaneDust = [totalArcaneDust copy];
        self->_hsYearCurrent = [hsYearCurrent copy];
    }
    
    return self;
}

- (void)dealloc {
    [_totalArcaneDust release];
    [_hsYearCurrent release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckImageRenderServiceAboutContentConfiguration *_copy = (DeckImageRenderServiceAboutContentConfiguration *)copy;
        _copy->_totalArcaneDust = [self.totalArcaneDust copy];
        _copy->_hsYearCurrent = [self.hsYearCurrent copy];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    DeckImageRenderServiceAboutContentView *contentView = [DeckImageRenderServiceAboutContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
