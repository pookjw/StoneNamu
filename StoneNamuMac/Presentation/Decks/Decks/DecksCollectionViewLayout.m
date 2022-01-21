//
//  DecksCollectionViewLayout.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import "DecksCollectionViewLayout.h"
#import "DeckBackgroundBox.h"

@implementation DecksCollectionViewLayout

- (instancetype)init {
    return [super initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger section, id<NSCollectionLayoutEnvironment> _Nonnull env) {
        NSCollectionLayoutSize *backgroundSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                                heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0f]];
        NSCollectionLayoutAnchor *backgroundContainerAnchor = [NSCollectionLayoutAnchor layoutAnchorWithEdges:NSDirectionalRectEdgeAll];
        NSCollectionLayoutSupplementaryItem *backgroundItem = [NSCollectionLayoutSupplementaryItem supplementaryItemWithLayoutSize:backgroundSize elementKind:NSCollectionViewDecorationElementKindDeckBackgroundBox containerAnchor:backgroundContainerAnchor];
        backgroundItem.zIndex = -1;
        
        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                          heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0f]];
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize supplementaryItems:@[backgroundItem]];
        
        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                           heightDimension:[NSCollectionLayoutDimension estimatedDimension:49.0f]];
        
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
        
        NSCollectionLayoutSection *layoutSection = [NSCollectionLayoutSection sectionWithGroup:group];
        
        return layoutSection;
    }];
}

@end
