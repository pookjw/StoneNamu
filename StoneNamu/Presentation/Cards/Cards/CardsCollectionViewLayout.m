//
//  CardsCollectionViewLayout.m
//  CardsCollectionViewLayout
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "CardsCollectionViewLayout.h"

@implementation CardsCollectionViewLayout

- (instancetype)init {
    NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f / 3.0f]
                                                                      heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0f]];
    
    NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
    
    NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                       heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.5f * (1.0f / 3.0f)]];
    
    NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
    
    NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
    
    self = [super initWithSection:section];
    
    return self;
}

@end
