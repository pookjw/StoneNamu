//
//  DeckImageRenderServiceAboutContentConfiguration.m
//  DeckImageRenderServiceAboutContentConfiguration
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "DeckImageRenderServiceAboutContentConfiguration.h"
#import "DeckImageRenderServiceAboutContentView.h"

@implementation DeckImageRenderServiceAboutContentConfiguration

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        
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
