//
//  CardDetailsCollectionViewLayout.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import "CardDetailsCollectionViewLayout.h"
#import "CardDetailsSectionModel.h"

@implementation CardDetailsCollectionViewLayout

- (instancetype)init {
    self = [super initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger section, id<NSCollectionLayoutEnvironment> _Nonnull layoutEnvironment) {
        
        switch (section) {
            case CardDetailsSectionModelTypeBase: case CardDetailsSectionModelTypeDetail: {
                NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                                  heightDimension:[NSCollectionLayoutDimension estimatedDimension:50.0f]];
                NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
                
                NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                                   heightDimension:[NSCollectionLayoutDimension estimatedDimension:50.0f]];
                
                NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
                
                NSCollectionLayoutSection *layoutSection = [NSCollectionLayoutSection sectionWithGroup:group];
                
                return layoutSection;
            }
            case CardDetailsSectionModelTypeChildren: {
                NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                                  heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0f]];
                
                NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
                item.contentInsets = NSDirectionalEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                
                NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension:200.0f]
                                                                                   heightDimension:[NSCollectionLayoutDimension absoluteDimension:300.0f]];
                
                NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
                
                NSCollectionLayoutSection *layoutSection = [NSCollectionLayoutSection sectionWithGroup:group];
                layoutSection.interGroupSpacing = 0.0f;
                layoutSection.orthogonalScrollingBehavior = NSCollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary;
                layoutSection.contentInsets = NSDirectionalEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                
                return layoutSection;
            }
            default:
                return nil;
        }
    }];
    
    return self;
    
}

@end
