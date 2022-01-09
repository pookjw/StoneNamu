//
//  DeckImageRenderServiceCollectionViewLayout.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import "DeckImageRenderServiceCollectionViewLayout.h"
#import "DeckImageRenderServiceModel.h"
#import "DeckImageRenderServiceSeparatorBox.h"

@implementation DeckImageRenderServiceCollectionViewLayout

- (instancetype)init {
    self = [self initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger section, id<NSCollectionLayoutEnvironment> _Nonnull env) {
        switch (section) {
            case DeckImageRenderServiceSectionModelTypeIntro: {
                NSCollectionLayoutSize *separatorSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                                       heightDimension:[NSCollectionLayoutDimension absoluteDimension:0.5f]];
                NSCollectionLayoutAnchor *seapratorContainerAnchor = [NSCollectionLayoutAnchor layoutAnchorWithEdges:NSDirectionalRectEdgeLeading | NSDirectionalRectEdgeBottom | NSDirectionalRectEdgeTrailing absoluteOffset:NSZeroPoint];
                NSCollectionLayoutSupplementaryItem *separatorItem = [NSCollectionLayoutSupplementaryItem supplementaryItemWithLayoutSize:separatorSize elementKind:NSStringFromClass([DeckImageRenderServiceSeparatorBox class]) containerAnchor:seapratorContainerAnchor];
                
                NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                                  heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0f]];
                NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize supplementaryItems:@[separatorItem]];
                
                NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                                   heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:(64.0f / 243.0f)]];
                
                NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitem:item count:1];
                
                NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
                
                return section;
            }
            default: {
                NSCollectionLayoutSize *separatorSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                                       heightDimension:[NSCollectionLayoutDimension absoluteDimension:0.5f]];
                NSCollectionLayoutAnchor *seapratorContainerAnchor = [NSCollectionLayoutAnchor layoutAnchorWithEdges:NSDirectionalRectEdgeLeading | NSDirectionalRectEdgeBottom | NSDirectionalRectEdgeTrailing absoluteOffset:NSZeroPoint];
                NSCollectionLayoutSupplementaryItem *separatorItem = [NSCollectionLayoutSupplementaryItem supplementaryItemWithLayoutSize:separatorSize elementKind:NSStringFromClass([DeckImageRenderServiceSeparatorBox class]) containerAnchor:seapratorContainerAnchor];
                
                NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                                  heightDimension:[NSCollectionLayoutDimension estimatedDimension:41.0f]];
                NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize supplementaryItems:@[separatorItem]];
                
                NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                                   heightDimension:[NSCollectionLayoutDimension estimatedDimension:41.0f]];
                
                NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
                
                NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
                
                return section;
            }
        }
    }];
    
    return self;
}

@end
