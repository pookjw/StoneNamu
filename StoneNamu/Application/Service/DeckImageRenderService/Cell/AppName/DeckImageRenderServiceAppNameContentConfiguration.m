//
//  DeckImageRenderServiceAppNameContentConfiguration.m
//  DeckImageRenderServiceAppNameContentConfiguration
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "DeckImageRenderServiceAppNameContentConfiguration.h"
#import "DeckImageRenderServiceAppNameContentView.h"

@implementation DeckImageRenderServiceAppNameContentConfiguration

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView {
    DeckImageRenderServiceAppNameContentView *contentView = [DeckImageRenderServiceAppNameContentView new];
    contentView.configuration = self;
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state {
    return self;
}

@end
