//
//  CardDetailsViewModel.m
//  CardDetailsViewModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import "CardDetailsViewModel.h"
#import "HSCardUseCaseImpl.h"
#import "BlizzardHSAPIKeys.h"

@interface CardDetailsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<HSCardUseCase> hsCardUseCase;
@end

@implementation CardDetailsViewModel

- (instancetype)initWithDataSource:(CardDetailsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        _dataSource = [dataSource retain];
        
        HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
        self.hsCardUseCase = hsCardUseCase;
        [hsCardUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_hsCardUseCase release];
    [_queue cancelAllOperations];
    [_queue release];
    [super dealloc];
}

- (void)requestDataSourceWithCard:(HSCard *)hsCard {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
        
        [snapshot deleteAllItems];
        
        CardDetailsSectionModel *sectionModelBase = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeBase];
        CardDetailsSectionModel *sectionModelDetail = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeDetail];
        
        [snapshot appendSectionsWithIdentifiers:@[sectionModelBase, sectionModelDetail]];
        
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
            [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeCollectible value:hsCardCollectiblesWithLocalizable()[NSStringFromHSCardCollectible(hsCard.collectible)]] autorelease],
            [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeArtist value:hsCard.artistName] autorelease]
        ]
                   intoSectionWithIdentifier:sectionModelDetail];
        
        //
        
        [sectionModelBase release];
        [sectionModelDetail release];
        
        [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
        
        //
        
        [self loadChildCardsWithHSCard:hsCard];
    }];
}

- (void)loadChildCardsWithHSCard:(HSCard *)hsCard {
    // won't be leaked
    #ifndef __clang_analyzer__
    NSArray<NSNumber *> *childIds = [hsCard.childIds copy];
    #endif
    if (childIds.count == 0) {
        [childIds release];
        return;
    }
    
    [self.queue addOperationWithBlock:^{
        NSCondition *condition = [NSCondition new];
        NSInteger __block count = -((NSInteger)childIds.count);
        NSMutableArray *childCards = [@[] mutableCopy];
        
        for (NSNumber *childId in childIds) {
            [self.hsCardUseCase fetchWithIdOrSlug:[childId stringValue]
                                      withOptions:nil
                                completionHandler:^(HSCard * _Nullable childCard, NSError * _Nullable error) {
                if (childCard) {
                    [childCards addObject:childCard];
                }
                
                count += 1;
                [condition signal];
            }];
        }
        
        while (count != 0) {
            [condition wait];
        }
        
        NSArray<HSCard *> *results = [childCards copy];
        [childIds release];
        [condition release];
        [childCards release];
        
        [self updateDataSourceWithChildCards:results];
        [results autorelease];
    }];
}

- (void)updateDataSourceWithChildCards:(NSArray<HSCard *> *)childCards {
    [childCards retain];
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
        
        CardDetailsSectionModel *sectionModelChildren = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeChildren];
        
        if ([snapshot.sectionIdentifiers containsObject:sectionModelChildren]) {
            [snapshot deleteSectionsWithIdentifiers:@[sectionModelChildren]];
        }
        
        [snapshot appendSectionsWithIdentifiers:@[sectionModelChildren]];
        
        CardDetailsItemModel *childCardsItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeChildren childCards:childCards];
        
        [snapshot appendItemsWithIdentifiers:@[childCardsItem] intoSectionWithIdentifier:sectionModelChildren];
        
        [sectionModelChildren release];
        [childCards release];
        [childCardsItem release];
        
        [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
    }];
}

@end
