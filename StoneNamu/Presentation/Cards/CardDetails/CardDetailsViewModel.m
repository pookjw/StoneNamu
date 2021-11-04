//
//  CardDetailsViewModel.m
//  CardDetailsViewModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import "CardDetailsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "DragItemService.h"

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
    [_queue release];
    [_hsCard release];
    [super dealloc];
}

- (void)requestDataSourceWithCard:(HSCard *)hsCard {
    [self.queue addBarrierBlock:^{
        [self->_hsCard release];
        self->_hsCard = nil;
        self->_hsCard = [hsCard copy];
        
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        CardDetailsSectionModel *sectionModelBase = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeBase];
        CardDetailsSectionModel *sectionModelDetail = [[CardDetailsSectionModel alloc] initWithType:CardDetailsSectionModelTypeDetail];
        
        [snapshot appendSectionsWithIdentifiers:@[sectionModelBase, sectionModelDetail]];
        
        //
        
        NSString * _Nullable cardClassValue = nil;
        
        if (hsCard.multiClassIds != nil) {
            NSMutableArray *strings = [@[] mutableCopy];
            
            for (NSNumber *classId in hsCard.multiClassIds) {
                [strings addObject:hsCardClassesWithLocalizable()[NSStringFromHSCardClass(classId.unsignedIntegerValue)]];
            }
            
            cardClassValue = [strings componentsJoinedByString:@", "];
            [strings release];
        }
        
        if ((cardClassValue == nil) || ([cardClassValue isEqualToString:@""])) {
            cardClassValue = hsCardClassesWithLocalizable()[NSStringFromHSCardClass(hsCard.classId)];
        }
        
        @autoreleasepool {
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
                
                [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeClass value:cardClassValue] autorelease],
                
                [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeCollectible value:hsCardCollectiblesWithLocalizable()[NSStringFromHSCardCollectible(hsCard.collectible)]] autorelease],
                
                [[[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeArtist value:hsCard.artistName] autorelease]
            ]
                       intoSectionWithIdentifier:sectionModelDetail];
        }
        
        //
        
        [sectionModelBase release];
        [sectionModelDetail release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
            [self loadChildCardsWithHSCard:hsCard];
        }];
    }];
}

- (NSArray<UIDragItem *> *)makeDragItemFromImage:(UIImage * _Nullable)image {
    UIDragItem *dragItem = [DragItemService.sharedInstance makeDragItemsFromHSCard:self.hsCard image:image];
    
    return @[dragItem];
}

- (void)loadChildCardsWithHSCard:(HSCard *)hsCard {
    NSArray<NSNumber *> *childIds = [hsCard.childIds copy];
    if (childIds.count == 0) {
        [childIds release];
        return;
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:CardDetailsViewModelStartFetchingChildCardsNotificationName
                                                      object:self
                                                    userInfo:nil];
    
    [self.queue addOperationWithBlock:^{
        NSSemaphoreCondition *semaphore = [[NSSemaphoreCondition alloc] initWithValue:-((NSInteger)childIds.count) + 1];
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
        
        CardDetailsItemModel *childCardsItem = [[CardDetailsItemModel alloc] initWithType:CardDetailsItemModelTypeChildren childCards:childCards];
        
        [snapshot appendItemsWithIdentifiers:@[childCardsItem] intoSectionWithIdentifier:sectionModelChildren];
        
        [sectionModelChildren release];
        [childCardsItem release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
            [NSNotificationCenter.defaultCenter postNotificationName:CardDetailsViewModelStartFetchedChildCardsNotificationName
                                                              object:self
                                                            userInfo:nil];
        }];
    }];
}

@end
