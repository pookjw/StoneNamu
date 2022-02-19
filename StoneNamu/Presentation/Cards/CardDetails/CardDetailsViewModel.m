//
//  CardDetailsViewModel.m
//  CardDetailsViewModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import "CardDetailsViewModel.h"
#import <StoneNamuResources/StoneNamuResources.h>
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "NSDiffableDataSourceSnapshot+sort.h"
#import "DragItemService.h"

@interface CardDetailsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@property (retain) id<HSCardUseCase> hsCardUseCase;
@end

@implementation CardDetailsViewModel

- (instancetype)initWithDataSource:(CardDetailsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        self.contextMenuIndexPath = nil;
        
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
        
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
    [_contextMenuIndexPath release];
    [_hsMetaDataUseCase release];
    [_hsCardUseCase release];
    [_queue release];
    [_hsCard release];
    [super dealloc];
}

- (void)requestDataSourceWithCard:(HSCard *)hsCard {
    [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error) {
        [self.queue addBarrierBlock:^{
            [self postStartedLoadingDataSource];
            
            [self->_hsCard release];
            self->_hsCard = [hsCard copy];
            
            NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
            
            [snapshot deleteAllItems];
            
            CardDetailsSectionModel *baseSectionModel = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeBase];
            CardDetailsSectionModel *detailSectionModel = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeDetail];
            
            //
            
            NSString * _Nullable cardClassValue = nil;
            
            if (hsCard.multiClassIds != nil) {
                NSMutableArray *strings = [@[] mutableCopy];
                
                [hsCard.multiClassIds enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    HSCardClass * _Nullable hsCardClass = [self.hsMetaDataUseCase hsCardClassFromClassId:obj usingHSMetaData:hsMetaData];
                    
                    if (hsCardClass) {
                        [strings addObject:hsCardClass.name];
                    }
                }];
                
                cardClassValue = [strings componentsJoinedByString:@", "];
                [strings release];
            }
            
            if ((cardClassValue == nil) || ([cardClassValue isEqualToString:@""])) {
                HSCardClass * _Nullable hsCardClass = [self.hsMetaDataUseCase hsCardClassFromClassId:hsCard.classId usingHSMetaData:hsMetaData];
                if (hsCardClass) {
                    cardClassValue = hsCardClass.name;
                }
            }
            
            //
            
            CardDetailsItemModel *nameItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeName value:hsCard.name];
            
            CardDetailsItemModel *flavorTextItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeFlavorText value:hsCard.flavorText];
            
            CardDetailsItemModel *textItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeText value:hsCard.text];
            
            HSCardType * _Nullable hsCardType = [self.hsMetaDataUseCase hsCardTypeFromTypeId:hsCard.cardTypeId usingHSMetaData:hsMetaData];
            CardDetailsItemModel *typeItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeType value:hsCardType.name];
            
            HSCardRarity * _Nullable hsCardRarity = [self.hsMetaDataUseCase hsCardRarityFromRarityId:hsCard.rarityId usingHSMetaData:hsMetaData];
            CardDetailsItemModel *rarityItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeRarity value:hsCardRarity.name];
            
            HSCardSet * _Nullable hsCardSet = [self.hsMetaDataUseCase hsCardSetFromSetId:hsCard.cardSetId usingHSMetaData:hsMetaData];
            CardDetailsItemModel *setItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeSet value:hsCardSet.name];
            
            CardDetailsItemModel *classItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeClass value:cardClassValue];
            
            CardDetailsItemModel *collectibleItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeCollectible value:NSStringFromHSCardCollectible(hsCard.collectible)];
            
            CardDetailsItemModel *artistNameItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeArtist value:hsCard.artistName];
            
            //
            
            [snapshot appendSectionsWithIdentifiers:@[baseSectionModel, detailSectionModel]];
            
            [snapshot appendItemsWithIdentifiers:@[nameItem, flavorTextItem, textItem] intoSectionWithIdentifier:baseSectionModel];
            [snapshot appendItemsWithIdentifiers:@[typeItem, rarityItem, setItem, classItem, collectibleItem, artistNameItem] intoSectionWithIdentifier:detailSectionModel];
            
            //
            
            [baseSectionModel release];
            [detailSectionModel release];
            
            [nameItem release];
            [flavorTextItem release];
            [textItem release];
            [typeItem release];
            [rarityItem release];
            [setItem release];
            [classItem release];
            [collectibleItem release];
            [artistNameItem release];
            
            [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                [self postEndedLoadingDataSource];
                [self loadChildCardsWithHSCard:hsCard];
            }];
            [snapshot release];
        }];
    }];
}

- (NSArray<UIDragItem *> *)makeDragItemFromImage:(UIImage * _Nullable)image indexPath:(NSIndexPath * _Nullable)indexPath {
    UIDragItem *dragItem;
    
    if (indexPath == nil) {
        // dragging for primaryImageView
        dragItem = [DragItemService.sharedInstance makeDragItemsFromHSCard:self.hsCard image:image];
    } else {
        // dragging for collectionView
        HSCard * _Nullable hsCard = [self.dataSource itemIdentifierForIndexPath:indexPath].childHSCard;
        
        if (hsCard == nil) {
            return @[];
        } else {
            dragItem = [DragItemService.sharedInstance makeDragItemsFromHSCard:hsCard image:image];
        }
    }
    
    return @[dragItem];
}

- (void)loadChildCardsWithHSCard:(HSCard *)hsCard {
    NSArray<NSNumber *> *childIds = [hsCard.childIds copy];
    if (childIds.count == 0) {
        [childIds release];
        return;
    }
    
    [self postStartedFetchingChildCards];
    
    [self.queue addOperationWithBlock:^{
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:-((NSInteger)childIds.count) + 1];
        NSMutableArray<HSCard *> *childCards = [@[] mutableCopy];
        
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
                                                    userInfo:nil];
}

@end
