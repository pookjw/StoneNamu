//
//  DecksCollectionViewLayout.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import "DecksCollectionViewLayout.h"

@implementation DecksCollectionViewLayout

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
