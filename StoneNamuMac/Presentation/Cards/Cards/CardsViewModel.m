//
//  CardsViewModel.m
//  CardsViewModel
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "CardsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "NSCollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface CardsViewModel ()
@property (retain) id<HSCardUseCase> hsCardUseCase;
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@property (readonly, nonatomic) NSDictionary<NSString *, NSSet<NSString *> *> *defaultOptions;
@property (retain) NSNumber * _Nullable pageCount;
@property (retain) NSNumber *page;
@property (nonatomic, readonly) BOOL canLoadMore;
@property BOOL isFetching;
@property (retain) NSOperationQueue *queue;
@property (retain) id<PrefsUseCase> prefsUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@end

@implementation CardsViewModel

- (instancetype)initWithDataSource:(CardsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
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
        
        PrefsUseCaseImpl *prefsUseCase = [PrefsUseCaseImpl new];
        self.prefsUseCase = prefsUseCase;
        [prefsUseCase release];
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        self.pageCount = nil;
        self.page = [NSNumber numberWithUnsignedInt:1];
        self.isFetching = NO;
        
        [self startObserving];
        [self postShouldUpdateOptions];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_hsCardUseCase release];
    [_hsMetaDataUseCase release];
    [_pageCount release];
    [_page release];
    [_queue release];
    [_options release];
    [_prefsUseCase release];
    [_dataCacheUseCase release];
    [super dealloc];
}

- (NSDictionary<NSString *, NSSet<NSString *> *> *)defaultOptions {
    return BlizzardHSAPIDefaultOptions();
}

- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options reset:(BOOL)reset {
    if (reset) {
        [self resetDataSource];
    } else {
        if (self.isFetching) return NO;
        if (!self.canLoadMore) return NO;
        [self.queue cancelAllOperations];
    }
    
    //
    
    NSBlockOperation * __block op = [NSBlockOperation new];
    
    [op addExecutionBlock:^{
        self.isFetching = YES;
        
        NSDictionary<NSString *, NSSet<NSString *> *> *defaultOptions = self.defaultOptions;
        NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable finalOptions = [options dictionaryByCombiningWithDictionary:defaultOptions shouldOverride:NO];
        
        if (finalOptions == nil) {
            [self->_options release];
            self->_options = [defaultOptions copy];
        } else {
            [self->_options release];
            self->_options = [finalOptions copy];
        }
        
        //
        
        [self postStartedLoadingDataSourceWithOptions:self.options];
        
        //
        
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableDic = [self.options mutableCopy];
        
        if (self.pageCount != nil) {
            // Next page
            NSNumber *nextPage = [NSNumber numberWithUnsignedInt:[self.page unsignedIntValue] + 1];
            mutableDic[BlizzardHSAPIOptionTypePage] = [NSSet setWithObject:[nextPage stringValue]];
        } else {
            // Initial data
            mutableDic[BlizzardHSAPIOptionTypePage] = [NSSet setWithObject:[self.page stringValue]];
        }
        
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:0];
        
        [self.hsCardUseCase fetchWithOptions:mutableDic completionHandler:^(NSArray<HSCard *> * _Nullable cards, NSNumber *pageCount, NSNumber *page, NSError * _Nullable error) {
            
            if (op.isCancelled) {
                [semaphore signal];
                return;
            }
            
            if (error) {
                [self postError:error];
                [semaphore signal];
                return;
            }
            
            [semaphore signal];
            
            [self updateDataSourceWithCards:cards completion:^{
                self.pageCount = pageCount;
                self.page = page;
                self.isFetching = NO;
            }];
        }];
        
        [mutableDic release];
        [semaphore wait];
        [semaphore release];
    }];
    
    [self.queue addOperation:op];
    [op release];
    
    return YES;
}

- (void)hsCardsFromIndexPathsWithCompletion:(NSSet<NSIndexPath *> *)indexPaths completion:(CardsViewModelHSCardsFromIndexPathsCompletion)completion {
    [self.queue addBarrierBlock:^{
        completion([self hsCardsFromIndexPaths:indexPaths]);
    }];
}

- (NSSet<HSCard *> *)hsCardsFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    NSMutableSet<HSCard *> *hsCards = [NSMutableSet<HSCard *> new];
    
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        HSCard * _Nullable hsCard = [self.dataSource itemIdentifierForIndexPath:obj].hsCard;
        
        if (hsCard == nil) return;
        
        [hsCards addObject:hsCard];
    }];
    
    return [hsCards autorelease];
}

- (void)resetDataSource {
    [self.queue cancelAllOperations];
    
    [self.queue addBarrierBlock:^{
        self.pageCount = nil;
        self.page = [NSNumber numberWithUnsignedInt:1];
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        [snapshot deleteAllItems];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:NO completion:^{}];
        [snapshot release];
    }];
}

- (BOOL)canLoadMore {
    if (self.pageCount == nil) {
        return YES;
    }
    return ![self.pageCount isEqual:self.page];
}

- (void)updateDataSourceWithCards:(NSArray<HSCard *> *)cards completion:(void (^)(void))completion {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        CardSectionModel * _Nullable sectionModel = nil;
        
        for (CardSectionModel *tmp in snapshot.sectionIdentifiers) {
            if (tmp.type == CardSectionModelTypeCards) {
                sectionModel = tmp;
            }
        }
        
        if (sectionModel == nil) {
            CardSectionModel *_sectionModel = [[CardSectionModel alloc] initWithType:CardSectionModelTypeCards];
            sectionModel = _sectionModel;
            [snapshot appendSectionsWithIdentifiers:@[_sectionModel]];
            [_sectionModel autorelease];
        }
        
        NSMutableArray<CardItemModel *> *itemModels = [@[] mutableCopy];
        
        for (HSCard *card in cards) {
            CardItemModel *itemModel = [[CardItemModel alloc] initWithCard:card];
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

- (void)startObserving {
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

- (void)postError:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardsViewModelError
                                                      object:self
                                                    userInfo:@{CardsViewModelErrorNotificationErrorKey: error}];
}

- (void)postStartedLoadingDataSourceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> *)options {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardsViewModelStartedLoadingDataSource
                                                      object:self
                                                    userInfo:@{NSNotificationNameCardsViewModelStartedLoadingDataSourceOptionsKey: options}];
}

- (void)postEndedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardsViewModelEndedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postShouldUpdateOptions {
    [self.queue addOperationWithBlock:^{
        [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
            
            [self.queue addOperationWithBlock:^{
                NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *slugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:nil withClassId:nil usingHSMetaData:hsMetaData];
                NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *slugsAndIds = [self.hsMetaDataUseCase optionTypesAndSlugsAndIdsFromHSDeckFormat:nil withClassId:nil usingHSMetaData:hsMetaData];
                
                [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardsViewModelShouldUpdateOptions
                                                                  object:self
                                                                userInfo:@{CardsViewModelShouldUpdateOptionsSlugsAndNamesItemKey: slugsAndNames,
                                                                           CardsViewModelShouldUpdateOptionsSlugsAndIdsItemKey: slugsAndIds}];
            }];
        }];
    }];
}

@end
