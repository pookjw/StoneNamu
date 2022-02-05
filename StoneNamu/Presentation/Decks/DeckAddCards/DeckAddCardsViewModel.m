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
@property (readonly, nonatomic) NSDictionary<NSString *, NSString *> *defaultOptions;
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
        [self->_contextMenuIndexPath release];
        self->_contextMenuIndexPath = nil;
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        [self->_options release];
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

- (void)defaultOptionsWithCompletion:(DeckAddCardsViewModelDefaultOptionsCompletion)completion {
    [self.queue addOperationWithBlock:^{
        completion(self.defaultOptions);
    }];
}

- (void)countOfLocalDeckCardsWithCompletion:(DeckAddCardsViewModelCountOfLocalDeckCardsCompletion)completion {
    [self.queue addOperationWithBlock:^{
        NSNumber * _Nullable count = nil;
        
        if (self.localDeck != nil) {
            count = [NSNumber numberWithUnsignedInteger:self.localDeck.hsCards.count];
        }
        BOOL isFull = count.unsignedIntegerValue >= HSDECK_MAX_TOTAL_CARDS;
        completion(count, isFull);
    }];
}

- (NSDictionary<NSString *, NSString *> *)defaultOptions {
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

- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options reset:(BOOL)reset {
    if (reset) {
        [self resetDataSource];
    } else {
        if (self.isFetching) return NO;
        if (!self.canLoadMore) return NO;
        [self.queue cancelAllOperations];
    }
    
    //
    
    self.isFetching = YES;
    
    NSBlockOperation * __block op = [NSBlockOperation new];
    
    [op addExecutionBlock:^{
        NSDictionary<NSString *, NSString *> *defaultOptions = self.defaultOptions;
        
        if (options == nil) {
            [self->_options release];
            self->_options = [defaultOptions copy];
        } else {
            NSDictionary *mutableDic = [options dictionaryByCombiningWithDictionary:defaultOptions shouldOverride:NO];
            [self->_options release];
            self->_options = [mutableDic copy];
        }
        
        //
        
        [self postStartedLoadingDataSource];
        
        //
        
        NSMutableDictionary *mutableDic = [self.options mutableCopy];
        
        if (self.pageCount != nil) {
            // Next page
            NSNumber *nextPage = [NSNumber numberWithUnsignedInt:[self.page unsignedIntValue] + 1];
            mutableDic[BlizzardHSAPIOptionTypePage] = [nextPage stringValue];
        } else {
            // Initial data
            mutableDic[BlizzardHSAPIOptionTypePage] = [self.page stringValue];
        }
        
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:0];
        
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

- (void)resetDataSource {
    [self.queue cancelAllOperations];
    
    [self.queue addOperationWithBlock:^{
        self.pageCount = nil;
        self.page = [NSNumber numberWithUnsignedInt:1];
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        [snapshot deleteAllItems];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
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

- (void)addHSCards:(NSSet<HSCard *> *)hsCards {
    [self.localDeckUseCase addHSCards:hsCards.allObjects toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
        if (error != nil) {
            [self postError:error];
        }
    }];
}

- (void)addHSCardsFromIndexPathes:(NSSet<NSIndexPath *> *)indexPathes {
    [self.queue addBarrierBlock:^{
        NSMutableSet<HSCard *> *hsCards = [NSMutableSet<HSCard *> new];
        
        [indexPathes enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
            HSCard * _Nullable hsCard = [self.dataSource itemIdentifierForIndexPath:obj].card;
            
            if (hsCard != nil) {
                [hsCards addObject:hsCard];
            }
        }];
        
        [self addHSCards:hsCards];
        [hsCards autorelease];
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
        
        NSArray<HSCard *> *localDeckCards = self.localDeck.hsCards;
        NSMutableArray<DeckAddCardItemModel *> *itemModels = [@[] mutableCopy];
        
        for (HSCard *card in cards) {
            NSUInteger count = [localDeckCards countOfObject:card];
            DeckAddCardItemModel *itemModel = [[DeckAddCardItemModel alloc] initWithCard:card count:count];
            [itemModels addObject:itemModel];
            [itemModel release];
        }
        
        [snapshot appendItemsWithIdentifiers:[[itemModels copy] autorelease] intoSectionWithIdentifier:sectionModel];
        
        [itemModels release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            completion();
            [self postEndedLoadingDataSource];
        }];
        [snapshot release];
    }];
}

- (void)updateItemCountToDataSource {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        NSArray<HSCard *> *localDeckCards = self.localDeck.hsCards;
        
        for (DeckAddCardItemModel *itemModel in snapshot.itemIdentifiers) {
            NSUInteger count = [localDeckCards countOfObject:itemModel.card];
            
            if (itemModel.count != count) {
                itemModel.count = count;
                [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
            }
        }
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:NSNotificationNameLocalDeckUseCaseObserveData
                                             object:self.localDeckUseCase];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(prefsChangedEventReceived:)
                                               name:NSNotificationNamePrefsUseCaseObserveData
                                             object:self.prefsUseCase];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(dataCacheDeletedEventReceived:)
                                               name:NSNotificationNameDataCacheUseCaseDeleteAll
                                             object:nil];
}

- (void)prefsChangedEventReceived:(NSNotification *)notification {
    [self requestDataSourceWithOptions:self.options reset:YES];
}

- (void)dataCacheDeletedEventReceived:(NSNotification *)notification {
    [self requestDataSourceWithOptions:self.options reset:YES];
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
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardsViewModelError
                                                      object:self
                                                    userInfo:@{DeckAddCardsViewModelErrorNotificationErrorKey: error}];
}

- (void)postStartedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postEndedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardsViewModelEndedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postLocalDeckHasChanged {
    [self countOfLocalDeckCardsWithCompletion:^(NSNumber * _Nullable countOfLocalDeckCards, BOOL isFull) {
        [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardsViewModelLocalDeckHasChanged
                                                          object:self
                                                        userInfo:@{DeckAddCardsViewModelLocalDeckHasChangedCountOfLocalDeckCardsItemKey: countOfLocalDeckCards}];
    }];
}

@end
