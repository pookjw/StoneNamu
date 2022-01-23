//
//  DeckDetailsCollectionViewLayout.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import "DeckDetailsCollectionViewLayout.h"
#import "DeckDetailsSeparatorBox.h"

@implementation DeckDetailsCollectionViewLayout

- (instancetype)init {
    NSCollectionLayoutSize *separatorSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                           heightDimension:[NSCollectionLayoutDimension absoluteDimension:0.5f]];
    NSCollectionLayoutAnchor *seapratorContainerAnchor = [NSCollectionLayoutAnchor layoutAnchorWithEdges:NSDirectionalRectEdgeLeading | NSDirectionalRectEdgeBottom | NSDirectionalRectEdgeTrailing absoluteOffset:NSZeroPoint];
    NSCollectionLayoutSupplementaryItem *separatorItem = [NSCollectionLayoutSupplementaryItem supplementaryItemWithLayoutSize:separatorSize elementKind:NSStringFromClass([DeckDetailsSeparatorBox class]) containerAnchor:seapratorContainerAnchor];
    
    NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                      heightDimension:[NSCollectionLayoutDimension estimatedDimension:39.0f]];
    NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize supplementaryItems:@[separatorItem]];
    
    NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                       heightDimension:[NSCollectionLayoutDimension estimatedDimension:39.0f]];
    
    NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
    
    NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
    
    return [super initWithSection:section];
}

@end
