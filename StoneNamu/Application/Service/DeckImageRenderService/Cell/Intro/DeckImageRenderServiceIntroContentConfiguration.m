//
//  DeckImageRenderServiceIntroContentConfiguration.m
//  DeckImageRenderServiceIntroContentConfiguration
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "DeckImageRenderServiceIntroContentConfiguration.h"
#import "DeckImageRenderServiceIntroContentView.h"

@implementation DeckImageRenderServiceIntroContentConfiguration

- (instancetype)initWithClassId:(HSCardClass)classId totalArcaneDust:(NSNumber *)totalArcaneDust deckName:(NSString *)deckName {
    self = [self init];
    
    if (self) {
        self->_classId = classId;
        self->_totalArcaneDust = [totalArcaneDust copy];
        self->_deckName = [deckName copy];
    }
    
    return self;
}

- (void)dealloc {
    [_totalArcaneDust release];
    [_deckName release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckImageRenderServiceIntroContentConfiguration *_copy = (DeckImageRenderServiceIntroContentConfiguration *)copy;
        _copy->_classId = self.classId;
        _copy->_totalArcaneDust = [self.totalArcaneDust copy];
        _copy->_deckName = [self.deckName copy];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    DeckImageRenderServiceIntroContentView *contentView = [DeckImageRenderServiceIntroContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
