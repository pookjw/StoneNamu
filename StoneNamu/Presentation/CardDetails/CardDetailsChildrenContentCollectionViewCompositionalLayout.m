//
//  CardDetailsChildrenContentCollectionViewCompositionalLayout.m
//  CardDetailsChildrenContentCollectionViewCompositionalLayout
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import "CardDetailsChildrenContentCollectionViewCompositionalLayout.h"

@implementation CardDetailsChildrenContentCollectionViewCompositionalLayout

- (instancetype)init {
    NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:0.25]
                                                                      heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
    
    NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
    
    NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0]
                                                                       heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.5 * 0.25]];
    
    NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
    
    NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
    
    self = [super initWithSection:section];
    
    return self;
}

@end
