//
//  CardDetailsCollectionViewLayout.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 12/13/21.
//

#import "CardDetailsCollectionViewLayout.h"
#import "CardDetailsSectionModel.h"

@interface CardDetailsCollectionViewLayout ()
@property (assign) id<CardDetailsCollectionViewLayoutDelegate> cardDetailsCollectionViewLayoutDelegate;
@end

@implementation CardDetailsCollectionViewLayout

- (instancetype)initWithCardDetailsCollectionViewLayoutDelegate:(id<CardDetailsCollectionViewLayoutDelegate>)cardDetailsCollectionViewLayoutDelegate {
    CardDetailsCollectionViewLayout * __block unretainedSelf = self;
    
    self = [self initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger section, id<NSCollectionLayoutEnvironment> _Nonnull layoutEnvironment) {
        CardDetailsSectionModelType type = [unretainedSelf.cardDetailsCollectionViewLayoutDelegate cardDetailsCollectionViewLayout:self cardDetailsSectionModelTypeForSection:section];
        
        switch (type) {
            case CardDetailsSectionModelTypeBase: case CardDetailsSectionModelTypeDetail: {
                UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
                layoutConfiguration.backgroundColor = UIColor.clearColor;
                layoutConfiguration.showsSeparators = YES;
                
                UIListSeparatorConfiguration *separatorConfiguration = [[UIListSeparatorConfiguration alloc] initWithListAppearance:UICollectionLayoutListAppearanceInsetGrouped];
                
                UIVibrancyEffect *effect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark] style:UIVibrancyEffectStyleSeparator];
                separatorConfiguration.visualEffect = effect;
                
                layoutConfiguration.separatorConfiguration = separatorConfiguration;
                [separatorConfiguration release];
                
                NSCollectionLayoutSection *layoutSection = [NSCollectionLayoutSection sectionWithListConfiguration:layoutConfiguration layoutEnvironment:layoutEnvironment];
                [layoutConfiguration release];
                
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
                layoutSection.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary;
                layoutSection.contentInsets = NSDirectionalEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                
                return layoutSection;
            }
            default:
                return nil;
        }
    }];
    
    if (self) {
        self.cardDetailsCollectionViewLayoutDelegate = cardDetailsCollectionViewLayoutDelegate;
    }
    
    return self;
}

@end
