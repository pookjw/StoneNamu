//
//  CardDetailsCollectionViewLayout.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import "CardDetailsCollectionViewLayout.h"
#import "CardDetailsSectionModel.h"
#import "CardDetailsBackgroundBox.h"

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
                NSCollectionLayoutDecorationItem *backgroundItem = [NSCollectionLayoutDecorationItem backgroundDecorationItemWithElementKind:NSCollectionViewDecorationElementKindCardDetailsBackgroundBox];
                
                NSDirectionalEdgeInsets contentInsets = NSDirectionalEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
                backgroundItem.contentInsets = contentInsets;
                layoutSection.contentInsets = contentInsets;
                layoutSection.decorationItems = @[backgroundItem];
                
                return layoutSection;
            }
            case CardDetailsSectionModelTypeChildren: {
                NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                                  heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0f]];
                
                NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
                item.contentInsets = NSDirectionalEdgeInsetsZero;
                
                NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension:200.0f]
                                                                                   heightDimension:[NSCollectionLayoutDimension absoluteDimension:300.0f]];
                
                NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
                
                NSCollectionLayoutSection *layoutSection = [NSCollectionLayoutSection sectionWithGroup:group];
                
                NSDirectionalEdgeInsets contentInsets = NSDirectionalEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
                layoutSection.contentInsets = contentInsets;
                layoutSection.interGroupSpacing = 0.0f;
                layoutSection.orthogonalScrollingBehavior = NSCollectionLayoutSectionOrthogonalScrollingBehaviorContinuous;
                
                return layoutSection;
            }
            default:
                return nil;
        }
    }];
    
    NSNib *backgroundNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([CardDetailsBackgroundBox class]) bundle:NSBundle.mainBundle];
    [self registerNib:backgroundNib forDecorationViewOfKind:NSCollectionViewDecorationElementKindCardDetailsBackgroundBox];
    [backgroundNib release];
    
    return self;
}

@end
