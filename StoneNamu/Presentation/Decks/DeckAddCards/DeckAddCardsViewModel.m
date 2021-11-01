//
//  DeckAddCardsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "DeckAddCardsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "DragItemService.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface DeckAddCardsViewModel ()
@property (retain) id<HSCardUseCase> hsCardUseCase;
@property (retain) NSNumber * _Nullable pageCount;
@property (retain) NSNumber *page;
@property (nonatomic, readonly) BOOL canLoadMore;
@property BOOL isFetching;
@property (retain) NSOperationQueue *queue;
@property (retain) id<PrefsUseCase> prefsUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@end

@implementation DeckAddCardsViewModel

- (instancetype)initWithDataSource:(CardsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self->_contextMenuIndexPath = nil;
        self->_dataSource = [dataSource retain];
        self->_options = nil;
        self.localDeck = nil;
        
        HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
        self.hsCardUseCase = hsCardUseCase;
        [hsCardUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        queue.maxConcurrentOperationCount = 1;
        self.queue = queue;
        [queue release];
        
        PrefsUseCaseImpl *prefsUseCase = [PrefsUseCaseImpl new];
        self.prefsUseCase = prefsUseCase;
        [prefsUseCase release];
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        LocalDeckUseCaseImpl *localDeckUseCase = [LocalDeckUseCaseImpl new];
        self.localDeckUseCase = localDeckUseCase;
        [localDeckUseCase release];
        
        self.pageCount = nil;
        self.page = [NSNumber numberWithUnsignedInt:1];
        self.isFetching = NO;
        
        [self observePrefsChange];
        [self observeDataCachesDeleted];
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_localDeck release];
    [_contextMenuIndexPath release];
    [_dataSource release];
    [_hsCardUseCase release];
    [_pageCount release];
    [_page release];
    [_queue release];
    [_options release];
    [_prefsUseCase release];
    [_dataCacheUseCase release];
    [_localDeckUseCase release];
    [super dealloc];
}

- (BOOL)isLocalDeckCardFull {
    return (self.countOfLocalDeckCards >= HSDECK_MAX_TOTAL_CARDS);
}

- (NSUInteger)countOfLocalDeckCards {
    return self.localDeck.cards.count;
}

- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *,id> * _Nullable)options reset:(BOOL)reset {
    
    if (reset) {
        [self resetDataSource];
    } else {
        if (self.isFetching) return NO;
        if (!self.canLoadMore) return NO;
    }
    
    //
    
    self.isFetching = YES;
    
    NSBlockOperation *op = [NSBlockOperation new];
    
    [op addExecutionBlock:^{
       NSDictionary<NSString *, NSString *> *defaultOptions = BlizzardHSAPIDefaultOptions();
        
        if (options == nil) {
            self->_options = [defaultOptions copy];
        } else {
            [self->_options release];
            
            NSMutableDictionary *mutableDic = [options mutableCopy];
            
            for (NSString *key in defaultOptions.allKeys) {
                if (mutableDic[key] == nil) {
                    mutableDic[key] = defaultOptions[key];
                }
            }
            
            self->_options = [mutableDic copy];
            [mutableDic release];
        }
        
        NSMutableDictionary *mutableDic = [self.options mutableCopy];
        
        if (self.pageCount != nil) {
            // Next page
            NSNumber *nextPage = [NSNumber numberWithUnsignedInt:[self.page unsignedIntValue] + 1];
            mutableDic[BlizzardHSAPIOptionTypePage] = [nextPage stringValue];
        } else {
            // Initial data
            mutableDic[BlizzardHSAPIOptionTypePage] = [self.page stringValue];
        }
        
        NSSemaphoreCondition *semaphore = [[NSSemaphoreCondition alloc] initWithValue:0];
        
        [self.hsCardUseCase fetchWithOptions:mutableDic completionHandler:^(NSArray<HSCard *> * _Nullable cards, NSNumber *pageCount, NSNumber *page, NSError * _Nullable error) {
            
            [mutableDic release];
            
            if (op.isCancelled) {
                [semaphore signal];
                [semaphore release];
                return;
            }
            
            [semaphore signal];
            [semaphore release];
            
            if (error) {
                [self postError:error];
            }
            
            [self.queue addOperationWithBlock:^{
                [self updateDataSourceWithCards:cards completion:^{
                    self.pageCount = pageCount;
                    self.page = page;
                    self.isFetching = NO;
                }];
            }];
        }];
        
        [semaphore wait];
    }];
    
    [self.queue addOperation:op];
    [op release];
    
    return YES;
}

- (NSDictionary<NSString *, NSString *> *)optionsForLocalDeckClassId {
    if (self.localDeck == nil) return BlizzardHSAPIDefaultOptions();

    NSMutableDictionary<NSString *, NSString *> *options = [BlizzardHSAPIDefaultOptions() mutableCopy];
    options[BlizzardHSAPIOptionTypeClass] = NSStringFromHSCardClass(self.localDeck.classId.unsignedIntegerValue);

    HSCardSet cardSet;
    if ([self.localDeck.format isEqualToString:HSDeckFormatStandard]) {
        cardSet = HSCardSetStandardCards;
    } else if ([self.localDeck.format isEqualToString:HSDeckFormatWild]) {
        cardSet = HSCardSetWildCards;
    } else if ([self.localDeck.format isEqualToString:HSDeckFormatClassic]) {
        cardSet = HSCardSetClassicCards;
    } else {
        cardSet = HSCardSetWildCards;
    }
    options[BlizzardHSAPIOptionTypeSet] = NSStringFromHSCardSet(cardSet);

    return [options autorelease];
}

- (void)resetDataSource {
    [self.queue cancelAllOperations];
    
    [self.queue addOperationWithBlock:^{
        self.pageCount = nil;
        self.page = [NSNumber numberWithUnsignedInt:1];
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        [snapshot deleteAllItems];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:NO completion:^{
            [snapshot release];
        }];
    }];
}

- (BOOL)canLoadMore {
    if (self.pageCount == nil) {
        return YES;
    }
    return ![self.pageCount isEqual:self.page];
}

- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath image:(UIImage * _Nullable)image {
    DeckAddCardItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) return @[];
    
    UIDragItem *dragItem = [DragItemService.sharedInstance makeDragItemsFromHSCard:itemModel.card image:image];
    
    return @[dragItem];
}

- (void)addHSCards:(NSArray<HSCard *> *)hsCards {
    [self.localDeckUseCase addHSCards:hsCards toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
        if (error != nil) {
            [self postError:error];
        }
    }];
}

- (void)updateDataSourceWithCards:(NSArray<HSCard *> *)cards completion:(void (^)(void))completion {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        DeckAddCardSectionModel * _Nullable sectionModel = nil;
        
        for (DeckAddCardSectionModel *tmp in snapshot.sectionIdentifiers) {
            if (tmp.type == DeckCardsSectionModelTypeCards) {
                sectionModel = tmp;
            }
        }
        
        if (sectionModel == nil) {
            sectionModel = [[[DeckAddCardSectionModel alloc] initWithType:DeckCardsSectionModelTypeCards] autorelease];
            [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        }
        
        NSArray<HSCard *> *localDeckCards = self.localDeck.cards;
        NSMutableArray<DeckAddCardItemModel *> *itemModels = [@[] mutableCopy];
        
        for (HSCard *card in cards) {
            @autoreleasepool {
                NSUInteger count = [localDeckCards countOfObject:card];
                DeckAddCardItemModel *itemModel = [[DeckAddCardItemModel alloc] initWithCard:card count:count];
                [itemModels addObject:itemModel];
                [itemModel release];
            }
        }
        
        [snapshot appendItemsWithIdentifiers:[[itemModels copy] autorelease] intoSectionWithIdentifier:sectionModel];
        
        [itemModels release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
            completion();
            [self postApplyingSnapshotWasDone];
        }];
    }];
}

- (void)updateItemCountToDataSource {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        NSArray<HSCard *> *localDeckCards = self.localDeck.cards;
        
        for (DeckAddCardItemModel *itemModel in snapshot.itemIdentifiers) {
            NSUInteger count = [localDeckCards countOfObject:itemModel.card];
            
            if (itemModel.count != count) {
                itemModel.count = count;
                [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
            }
        }
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
        }];
    }];
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:LocalDeckUseCaseObserveDataNotificationName
                                             object:self.localDeckUseCase];
}

- (void)localDeckChangesReceived:(NSNotification *)notification {
    if (self.localDeck != nil) {
        [self.localDeckUseCase refreshObject:self.localDeck mergeChanges:NO completion:^{
            [self updateItemCountToDataSource];
            [self postLocalDeckHasChanged];
        }];
    }
}

- (void)postError:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:DeckAddCardsViewModelErrorNotificationName
                                                      object:self
                                                    userInfo:@{DeckAddCardsViewModelErrorNotificationErrorKey: error}];
}

- (void)postApplyingSnapshotWasDone {
    [NSNotificationCenter.defaultCenter postNotificationName:DeckAddCardsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName
                                                      object:self
                                                    userInfo:nil];
}

- (void)postLocalDeckHasChanged {
    [NSNotificationCenter.defaultCenter postNotificationName:DeckAddCardsViewModelLocalDeckHasChangedNotificationName
                                                      object:self
                                                    userInfo:nil];
}

- (void)observePrefsChange {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(prefsChangedEventReceived:)
                                               name:PrefsUseCaseObserveDataNotificationName
                                             object:self.prefsUseCase];
}

- (void)prefsChangedEventReceived:(NSNotification *)notification {
    [self requestDataSourceWithOptions:self.options reset:YES];
}

- (void)observeDataCachesDeleted {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(dataCacheDeletedEventReceived:)
                                               name:DataCacheUseCaseDeleteAllNotificationName
                                             object:nil];
}

- (void)dataCacheDeletedEventReceived:(NSNotification *)notification {
    [self requestDataSourceWithOptions:self.options reset:YES];
}

@end
