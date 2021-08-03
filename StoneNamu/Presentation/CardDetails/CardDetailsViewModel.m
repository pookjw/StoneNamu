//
//  CardDetailsViewModel.m
//  CardDetailsViewModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import "CardDetailsViewModel.h"

@implementation CardDetailsViewModel

- (instancetype)initWithDataSource:(CardDetailsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        _dataSource = [dataSource retain];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [super dealloc];
}

- (void)requestDataSourceWithCard:(HSCard *)hsCard {
    NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
    
    [snapshot deleteAllItems];
    
    CardDetailsSectionModel *sectionModelBase = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeBase];
    CardDetailsSectionModel *sectionModelDetail = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeDetail];
    CardDetailsSectionModel *sectionModelChildren = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeChildren];
    
    [snapshot appendSectionsWithIdentifiers:@[sectionModelBase, sectionModelDetail, sectionModelChildren]];
    
    //
    
    [snapshot appendItemsWithIdentifiers:@[
        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeName value:hsCard.name] autorelease],
        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeFlavorText value:hsCard.flavorText] autorelease],
        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeText value:hsCard.text] autorelease]
    ]
               intoSectionWithIdentifier:sectionModelBase];
    
    [snapshot appendItemsWithIdentifiers:@[
        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeType value:hsCardTypesWithLocalizable()[NSStringFromHSCardType(hsCard.cardTypeId)]] autorelease],
        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeRarity value:hsCardRaritiesWithLocalizable()[NSStringFromHSCardRarity(hsCard.rarityId)]] autorelease],
        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeSet value:hsCardSetsWithLocalizable()[NSStringFromHSCardSet(hsCard.cardSetId)]] autorelease],
        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeClass value:hsCardClassesWithLocalizable()[NSStringFromHSCardClass(hsCard.classId)]] autorelease],
        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeArtist value:hsCard.artistName] autorelease],
        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeCollectible value:hsCardCollectiblesWithLocalizable()[NSStringFromHSCardCollectible(hsCard.collectible)]] autorelease]
    ]
               intoSectionWithIdentifier:sectionModelDetail];
    
    //
    
    [sectionModelBase release];
    [sectionModelDetail release];
    [sectionModelChildren release];
    
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

@end
