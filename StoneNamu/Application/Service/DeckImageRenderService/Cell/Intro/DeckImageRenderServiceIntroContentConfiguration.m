//
//  DeckImageRenderServiceIntroContentConfiguration.m
//  DeckImageRenderServiceIntroContentConfiguration
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "DeckImageRenderServiceIntroContentConfiguration.h"
#import "DeckImageRenderServiceIntroContentView.h"

@implementation DeckImageRenderServiceIntroContentConfiguration

- (instancetype)initWithClassId:(HSCardClass)classId
                       deckName:(NSString *)deckName
                     deckFormat:(HSDeckFormat)deckFormat
                    isEasterEgg:(BOOL)isEasterEgg{
    self = [self init];
    
    if (self) {
        self->_classId = classId;;
        self->_deckName = [deckName copy];
        self->_deckFormat = [deckFormat copy];
        self->_isEasterEgg = isEasterEgg;
    }
    
    return self;
}

- (void)dealloc {
    [_deckName release];
    [_deckFormat release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckImageRenderServiceIntroContentConfiguration *_copy = (DeckImageRenderServiceIntroContentConfiguration *)copy;
        _copy->_classId = self.classId;
        _copy->_deckName = [self.deckName copy];
        _copy->_deckFormat = [self.deckFormat copy];
        _copy->_isEasterEgg = self.isEasterEgg;
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
