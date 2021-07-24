//
//  CardOptionsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsViewModel.h"
#import "BlizzardHSAPIKeys.h"

@implementation CardOptionsViewModel

- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        _dataSource = dataSource;
        [_dataSource retain];
        
        [self configureSnapshot];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [super dealloc];
}

- (void)configureSnapshot {
    NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
    
    [snapshot deleteAllItems];
    
    CardOptionsSectionModel *cardSectionModel = [[CardOptionsSectionModel alloc] initWithType:CardOptionsSectionModelTypeCard];
    CardOptionsSectionModel *sortSectionModel = [[CardOptionsSectionModel alloc] initWithType:CardOptionsSectionModelTypeSort];
    
    [snapshot appendSectionsWithIdentifiers:@[cardSectionModel, sortSectionModel]];
    [cardSectionModel release];
    [sortSectionModel release];
    
    @autoreleasepool {
        [snapshot appendItemsWithIdentifiers:@[
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeSet] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeClass] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeManaCost] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeAttack] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeHealth] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeCollectible] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeRarity] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeType] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeMinionType] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeKeyword] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeTextFilter] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeGameMode] autorelease]
        ]
                   intoSectionWithIdentifier:cardSectionModel];
        
        [snapshot appendItemsWithIdentifiers:@[
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeSort] autorelease]
        ]
                   intoSectionWithIdentifier:sortSectionModel];
    }
    
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

@end
