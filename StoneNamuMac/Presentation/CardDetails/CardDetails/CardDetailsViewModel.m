//
//  CardDetailsViewModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import "CardDetailsViewModel.h"
#import <StoneNamuResources/StoneNamuResources.h>
#import "NSCollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "NSDiffableDataSourceSnapshot+sort.h"

@interface CardDetailsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<HSCardUseCase> hsCardUseCase;
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@end

@implementation CardDetailsViewModel

- (instancetype)initWithDataSource:(CardDetailsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_hsCard release];
        self->_hsCard = nil;
        
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
        HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
        self.hsCardUseCase = hsCardUseCase;
        [hsCardUseCase release];
        
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
        
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
    [_hsMetaDataUseCase release];
    [_queue release];
    [_hsCard release];
    [super dealloc];
}

- (void)requestDataSourceWithCard:(HSCard *)hsCard {
    [self.queue addBarrierBlock:^{
        [self->_hsCard release];
        self->_hsCard = [hsCard copy];
        
        [self postStartedLoadingDataSource];
        
        [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error) {
            [self.queue addBarrierBlock:^{
                NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
                
                [snapshot deleteAllItems];
                
                CardDetailsSectionModel *sectionModelBase = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeBase];
                CardDetailsSectionModel *sectionModelDetail = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeDetail];
                
                [snapshot appendSectionsWithIdentifiers:@[sectionModelBase, sectionModelDetail]];
                
                //
                
                NSString * _Nullable cardClassValue = nil;
                
                if (hsCard.multiClassIds != nil) {
                    NSMutableArray<NSString *> *strings = [NSMutableArray<NSString *> new];
                    
                    for (NSNumber *classId in hsCard.multiClassIds) {
                        [strings addObject:[self.hsMetaDataUseCase hsCardClassFromClassId:classId usingHSMetaData:hsMetaData].name];
                    }
                    
                    cardClassValue = [strings componentsJoinedByString:@", "];
                    [strings release];
                }
                
                if ((cardClassValue == nil) || ([cardClassValue isEqualToString:@""])) {
                    cardClassValue = [self.hsMetaDataUseCase hsCardClassFromClassId:hsCard.classId usingHSMetaData:hsMetaData].name;
                }
                
                @autoreleasepool {
                    [snapshot appendItemsWithIdentifiers:@[
                        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeName value:hsCard.name] autorelease],
                        
                        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeFlavorText value:hsCard.flavorText] autorelease],
                        
                        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeText value:hsCard.text] autorelease]
                    ]
                               intoSectionWithIdentifier:sectionModelBase];
                    
                    [snapshot appendItemsWithIdentifiers:@[
                        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeType value:[self.hsMetaDataUseCase hsCardTypeFromTypeId:hsCard.cardTypeId usingHSMetaData:hsMetaData].name] autorelease],
                        
                        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeRarity value:[self.hsMetaDataUseCase hsCardRarityFromRarityId:hsCard.rarityId usingHSMetaData:hsMetaData].name] autorelease],
                        
                        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeSet value:[self.hsMetaDataUseCase hsCardSetFromSetId:hsCard.cardSetId usingHSMetaData:hsMetaData].name] autorelease],
                        
                        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeClass value:cardClassValue] autorelease],
                        
                        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeCollectible value:[ResourcesService localizationForHSCardCollectible:hsCard.collectible]] autorelease],
                        
                        [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeArtist value:hsCard.artistName] autorelease]
                    ]
                               intoSectionWithIdentifier:sectionModelDetail];
                }
                
                //
                
                [sectionModelBase release];
                [sectionModelDetail release];
                
                [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                    [self postEndedLoadingDataSource];
                    [self loadChildCardsFromHSCard:hsCard];
                }];
                [snapshot release];
            }];
        }];
    }];
}

- (NSSet<HSCard *> *)hsCardsFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    NSMutableSet<HSCard *> *hsCards = [NSMutableSet<HSCard *> new];
    
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        HSCard * _Nullable hsCard = [self.dataSource itemIdentifierForIndexPath:obj].childHSCard;
        
        if (hsCard != nil) {
            [hsCards addObject:hsCard];
        }
    }];
    
    return [hsCards autorelease];
}

- (void)hsCardsFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths completion:(CardDetailsViewModelHSCardsFromIndexPathsCompletion)completion {
    [self.queue addBarrierBlock:^{
        NSSet<HSCard *> *hsCards = [self hsCardsFromIndexPaths:indexPaths];
        completion(hsCards);
    }];
}

- (void)loadChildCardsFromHSCard:(HSCard *)hsCard {
    NSArray<NSNumber *> *childIds = [hsCard.childIds copy];
    if (childIds.count == 0) {
        [childIds release];
        return;
    }
    
    [self postStartedFetchingChildCards];
    
    [self.queue addOperationWithBlock:^{
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:-((NSInteger)childIds.count) + 1];
        NSMutableArray<HSCard *> *childCards = [NSMutableArray<HSCard *> new];
        
        for (NSNumber *childId in childIds) {
            [self.hsCardUseCase fetchWithIdOrSlug:[childId stringValue]
                                      withOptions:nil
                                completionHandler:^(HSCard * _Nullable childCard, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                } else if (childCard) {
                    HSCard *copyCard = [childCard copy];
                    [childCards addObject:copyCard];
                    [copyCard release];
                }
                
                [semaphore signal];
            }];
        }
        
        [semaphore wait];
        [semaphore release];
        
        NSArray<HSCard *> *results = [childCards copy];
        [childIds release];
        [childCards release];
        
        [self updateDataSourceWithChildCards:results];
        [results autorelease];
    }];
}

- (void)updateDataSourceWithChildCards:(NSArray<HSCard *> *)childCards {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        CardDetailsSectionModel *sectionModelChildren = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeChildren];
        
        if ([snapshot.sectionIdentifiers containsObject:sectionModelChildren]) {
            [snapshot deleteSectionsWithIdentifiers:@[sectionModelChildren]];
        }
        
        [snapshot appendSectionsWithIdentifiers:@[sectionModelChildren]];
        
        [childCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CardDetailsItemModel *childCardItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeChild childHSCard:obj];
            [snapshot appendItemsWithIdentifiers:@[childCardItem] intoSectionWithIdentifier:sectionModelChildren];
            [childCardItem release];
        }];
        
        //
        
        [snapshot sortItemsWithSectionIdentifiers:@[sectionModelChildren] usingComparator:^NSComparisonResult(CardDetailsItemModel * _Nonnull obj1, CardDetailsItemModel * _Nonnull obj2) {
            return [obj1.childHSCard compare:obj2.childHSCard];
        }];
        
        [sectionModelChildren release];
        
        //
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [self postEndedFetchingChildCards];
            [self postEndedLoadingDataSource];
        }];
        [snapshot release];
    }];
}

- (void)postStartedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardDetailsViewModelStartedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postEndedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardDetailsViewModelEndedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postStartedFetchingChildCards {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardDetailsViewModelStartedFetchingChildCards
                                                      object:self
                                                    userInfo:nil];
}

- (void)postEndedFetchingChildCards {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardDetailsViewModelEndedFetchingChildCards
                                                      object:self
                                                    userInfo:@{NSNotificationNameCardDetailsViewModelEndedLoadingDataSourceHSCardItemKey: self.hsCard}];
}

@end
