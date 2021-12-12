//
//  DeckDetailsCollectionViewLayout.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import "DeckDetailsCollectionViewLayout.h"

@implementation DeckDetailsCollectionViewLayout

- (instancetype)init {
    NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                      heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0f]];
    NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
    
    NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                       heightDimension:[NSCollectionLayoutDimension absoluteDimension:41.0f]];
    
    NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
    
    NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
    
    return [super initWithSection:section];
}

@end
