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
@property BOOL startedLoadingUpgradedCard;
@property BOOL endedLoadingUpgradedCard;
@property BOOL startedLoadingChildHSCards;
@property BOOL endedLoadingChildHSCards;
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
        
        self.startedLoadingUpgradedCard = NO;
        self.endedLoadingUpgradedCard = NO;
        self.startedLoadingChildHSCards = NO;
        self.endedLoadingChildHSCards = NO;
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
    [_hsCardGameModeSlugType release];
    [super dealloc];
}

- (void)requestDataSourceWithCard:(HSCard *)hsCard {
    [self->_hsCard release];
    self->_hsCard = [hsCard copy];
    
    [self.hsCardUseCase animatedImageURLOfHSCard:hsCard completionHandler:^(NSURL * _Nullable url, NSError * _Nullable error) {
        if (url) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }];
        }
    }];
    
    [self.queue addBarrierBlock:^{
        [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error) {
            [self.queue addBarrierBlock:^{
                [self postStartedLoadingDataSource];
                [self loadCardsFromHSCard:hsCard];
                
                NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
                
                [snapshot deleteAllItems];
                
                CardDetailsSectionModel *baseSectionModel = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeBase];
                CardDetailsSectionModel *detailSectionModel = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeDetail];
                
                //
                
                NSString * _Nullable cardClassValue = nil;
                
                if (hsCard.multiClassIds != nil) {
                    NSMutableArray<NSString *> *strings = [NSMutableArray<NSString *> new];
                    
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
                
                CardDetailsItemModel *collectibleItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeCollectible value:[ResourcesService localizationForHSCardCollectible:hsCard.collectible]];
                
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
                    [self postEndedLoadingDataSourceIfNeeded];
                }];
                [snapshot release];
            }];
        }];
    }];
}

- (void)requestRecommendedImageURLWithCompletion:(CardDetailsViewModelRequestRecommendedImageURLCompletion)completion {
    [self.queue addOperationWithBlock:^{
        NSURL * _Nullable url = [self.hsCardUseCase recommendedImageURLOfHSCard:self.hsCard HSCardGameModeSlugType:self.hsCardGameModeSlugType isGold:self.isGold];
        completion(url);
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

- (void)loadCardsFromHSCard:(HSCard *)hsCard {
    NSNumber * _Nullable upgradedId = hsCard.battlegroundsUpgradeId;
    NSArray<NSNumber *> * _Nullable childIds = hsCard.childIds;
    
    // example: 52502-khadgar
    if ((upgradedId) && (childIds) && ([@[upgradedId] isEqualToArray:childIds])) {
        self.startedLoadingUpgradedCard = [self loadUpgradedCardFromHSCard:hsCard];
    } else {
        self.startedLoadingUpgradedCard = [self loadUpgradedCardFromHSCard:hsCard];
        self.startedLoadingChildHSCards = [self loadChildCardsFromHSCard:hsCard];
    }
}

- (BOOL)loadUpgradedCardFromHSCard:(HSCard *)hsCard {
    NSNumber * _Nullable upgradeId = hsCard.battlegroundsUpgradeId;
    if (upgradeId == nil) return NO;
    
    [self.queue addOperationWithBlock:^{
        [self.hsCardUseCase fetchWithIdOrSlug:upgradeId.stringValue withOptions:@{BlizzardHSAPIOptionTypeGameMode: [NSSet setWithObject:self.hsCardGameModeSlugType]} completionHandler:^(HSCard * _Nullable hsCard, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                self.endedLoadingUpgradedCard = YES;
                [self postEndedLoadingDataSourceIfNeeded];
                return;
            }
            
            [self appendChildHSCard:hsCard isGold:YES completion:^{
                self.endedLoadingUpgradedCard = YES;
                [self postEndedLoadingDataSourceIfNeeded];
            }];
        }];
    }];
    
    return YES;
}

- (BOOL)loadChildCardsFromHSCard:(HSCard *)hsCard {
    NSArray<NSNumber *> *childIds = hsCard.childIds;
    if (childIds.count == 0) {
        return NO;
    }
    
    [self.queue addOperationWithBlock:^{
        NSUInteger __block completed = 0;
        
        [childIds enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            void (^postWhenCompleted)(void) = ^{
                if (completed == childIds.count) {
                    self.endedLoadingChildHSCards = YES;
                    [self postEndedLoadingDataSourceIfNeeded];
                }
            };
            
            [self.hsCardUseCase fetchWithIdOrSlug:obj.stringValue withOptions:@{BlizzardHSAPIOptionTypeGameMode: [NSSet setWithObject:self.hsCardGameModeSlugType]} completionHandler:^(HSCard * _Nullable hsCard, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                    completed += 1;
                    postWhenCompleted();
                    return;
                }
                
                [self appendChildHSCard:hsCard isGold:self.isGold completion:^{
                    completed += 1;
                    postWhenCompleted();
                }];
            }];
        }];
    }];
    
    return YES;
}

- (void)appendChildHSCard:(HSCard *)hsCard isGold:(BOOL)isGold completion:(void (^)(void))completion {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        CardDetailsSectionModel * _Nullable __block childrenSectionModel = nil;
        
        [snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(CardDetailsSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            switch (obj.type) {
                case CardDetailsSectionModelTypeChildren:
                    childrenSectionModel = [obj retain];
                    *stop = YES;
                    break;
                default:
                    break;
            }
        }];
        
        if (childrenSectionModel == nil) {
            childrenSectionModel = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeChildren];
            [snapshot appendSectionsWithIdentifiers:@[childrenSectionModel]];
        }
        
        NSURL * _Nullable imageURL = [self.hsCardUseCase recommendedImageURLOfHSCard:hsCard HSCardGameModeSlugType:self.hsCardGameModeSlugType isGold:isGold];
        CardDetailsItemModel *childItemModel = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeChild childHSCard:hsCard imageURL:imageURL isGold:isGold];
        [snapshot appendItemsWithIdentifiers:@[childItemModel] intoSectionWithIdentifier:childrenSectionModel];
        [childItemModel release];
        
        [childrenSectionModel release];
        
        [snapshot sortItemsWithSectionIdentifiers:@[childrenSectionModel] usingComparator:^NSComparisonResult(CardDetailsItemModel * _Nonnull obj1, CardDetailsItemModel * _Nonnull obj2) {
            return [obj1.childHSCard compare:obj2.childHSCard];
        }];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            completion();
        }];
        
        [snapshot release];
    }];
}

- (void)postStartedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardDetailsViewModelStartedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postEndedLoadingDataSourceIfNeeded {
    BOOL shouldPost;
    
    if ((!self.startedLoadingUpgradedCard) && (!self.startedLoadingChildHSCards)) {
        shouldPost = YES;
    } else if ((self.endedLoadingUpgradedCard) && (!self.startedLoadingChildHSCards)) {
        shouldPost = YES;
    } else if ((!self.startedLoadingUpgradedCard) && (self.endedLoadingChildHSCards)) {
        shouldPost = YES;
    } else if (self.endedLoadingUpgradedCard && self.endedLoadingChildHSCards) {
        shouldPost = YES;
    } else {
        shouldPost = NO;
    }
    
    if (shouldPost) {
        [self postEndedLoadingDataSource];
    }
}


- (void)postEndedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardDetailsViewModelEndedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

@end
