//
//  DeckAddCardsViewModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/8/21.
//

#import "DeckAddCardsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "NSCollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "NSDiffableDataSourceSnapshot+Private.h"

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

- (instancetype)initWithDataSource:(DeckAddCardsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self.localDeck = nil;
        
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
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

- (void)loadLocalDeckFromURIRepresentation:(NSURL *)URIRepresentation completion:(DeckAddCardsViewModelLoadFromURIRepresentationCompletion)completion {
    [self.localDeckUseCase fetchUsingURI:URIRepresentation completion:^(NSArray<LocalDeck *> * _Nullable localDecks, NSError * _Nullable error) {
        if (error != nil) {
//            [self postError:error];
            completion(NO);
            return;
        }
        
        LocalDeck * _Nullable localDeck = localDecks.firstObject;
        
        if (localDeck == nil) {
            completion(NO);
            return;
        }
        
        self.localDeck = localDeck;
        completion(YES);
    }];
}

- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *,NSString *> *)options reset:(BOOL)reset {
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
        NSDictionary<NSString *, NSString *> *defaultOptions = [self optionsForLocalDeckClassId];
        
        if (options == nil) {
            [self->_options release];
            self->_options = [defaultOptions copy];
        } else {
            NSDictionary *dic = [options dictionaryByCombiningWithDictionary:defaultOptions shouldOverride:NO];
            [self->_options release];
            self->_options = [dic copy];
        }
        
        //
        
        [self postStartedLoadingDataSourceWithOptions:self.options];
        
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

- (void)hsCardsFromIndexPathsWithCompletion:(NSSet<NSIndexPath *> *)indexPaths completion:(DeckAddCardsViewModelHSCardsFromIndexPathsCompletion)completion {
    [self.queue addBarrierBlock:^{
        NSMutableSet<HSCard *> *hsCards = [NSMutableSet<HSCard *> new];
        
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
            HSCard * _Nullable hsCard = [self.dataSource itemIdentifierForIndexPath:obj].hsCard;
            
            if (hsCard == nil) return;
            
            [hsCards addObject:hsCard];
        }];
        
        completion([hsCards autorelease]);
    }];
}

- (void)resetDataSource{
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
            HSCard * _Nullable hsCard = [self.dataSource itemIdentifierForIndexPath:obj].hsCard;
            
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
            if (tmp.type == DeckAddCardSectionModelTypeCards) {
                sectionModel = tmp;
            }
        }
        
        if (sectionModel == nil) {
            DeckAddCardSectionModel *_sectionModel = [[DeckAddCardSectionModel alloc] initWithType:DeckAddCardSectionModelTypeCards];
            sectionModel = _sectionModel;
            [snapshot appendSectionsWithIdentifiers:@[_sectionModel]];
            [_sectionModel autorelease];
        }
        
        NSArray<HSCard *> *localDeckCards = self.localDeck.hsCards;
        NSMutableArray<DeckAddCardItemModel *> *itemModels = [@[] mutableCopy];
        
        for (HSCard *card in cards) {
            NSUInteger count = [localDeckCards countOfObject:card];
            DeckAddCardItemModel *itemModel = [[DeckAddCardItemModel alloc] initWithCard:card count:count];
            [itemModels addObject:itemModel];
            [itemModel release];
        }
        
        [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:sectionModel];
        
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
            NSUInteger count = [localDeckCards countOfObject:itemModel.hsCard];
            
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

- (void)postStartedLoadingDataSourceWithOptions:(NSDictionary<NSString *, NSString *> *)options {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSource
                                                      object:self
                                                    userInfo:@{NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSourceOptionsKey: options}];
}

- (void)postEndedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardsViewModelEndedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}


- (void)postLocalDeckHasChanged {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardsViewModelLocalDeckHasChanged
                                                      object:self
                                                    userInfo:nil];
}

@end