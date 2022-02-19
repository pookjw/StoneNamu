//
//  DeckImageRenderServiceAboutContentConfiguration.m
//  DeckImageRenderServiceAboutContentConfiguration
//
//  Created by Jinwoo Kim on 9/15/21.
//

#import "DeckImageRenderServiceAboutContentConfiguration.h"
#import "DeckImageRenderServiceAboutContentView.h"

@implementation DeckImageRenderServiceAboutContentConfiguration

- (instancetype)initWithTotalArcaneDust:(NSNumber *)totalArcaneDust hsYearCurrentName:(NSString *)hsYearCurrentName {
    self = [self init];
    
    if (self) {
        [self->_totalArcaneDust release];
        self->_totalArcaneDust = [totalArcaneDust copy];
        [self->_hsYearCurrentName release];
        self->_hsYearCurrentName = [hsYearCurrentName copy];
    }
    
    return self;
}

- (void)dealloc {
    [_totalArcaneDust release];
    [_hsYearCurrentName release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckImageRenderServiceAboutContentConfiguration *_copy = (DeckImageRenderServiceAboutContentConfiguration *)copy;
        [_copy->_totalArcaneDust release];
        _copy->_totalArcaneDust = [self.totalArcaneDust copyWithZone:zone];
        [_copy->_hsYearCurrentName release];
        _copy->_hsYearCurrentName = [self.hsYearCurrentName copyWithZone:zone];
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
