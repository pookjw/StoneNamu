//
//  DeckAddCardsViewModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/8/21.
//

#import "DeckAddCardsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "NSCollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface DeckAddCardsViewModel ()
@property (retain) id<HSCardUseCase> hsCardUseCase;
@property (retain) NSNumber * _Nullable pageCount;
@property (retain) NSNumber *page;
@property (nonatomic, readonly) BOOL canLoadMore;
@property BOOL isFetching;
@property (retain) NSOperationQueue *queue;
@property (retain) id<PrefsUseCase> prefsUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@end

@implementation DeckAddCardsViewModel

- (instancetype)initWithDataSource:(DeckAddCardsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
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
        
        self.pageCount = nil;
        self.page = [NSNumber numberWithUnsignedInt:1];
        self.isFetching = NO;
        
        [self observePrefsChange];
        [self observeDataCachesDeleted];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_hsCardUseCase release];
    [_pageCount release];
    [_page release];
    [_queue release];
    [_options release];
    [_prefsUseCase release];
    [_dataCacheUseCase release];
    [super dealloc];
}

- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *,NSString *> *)options reset:(BOOL)reset {
    
    if (reset) {
        [self postStartedLoadingDataSource];
        [self resetDataSource];
    } else {
        if (self.isFetching) return NO;
        if (!self.canLoadMore) return NO;
        [self postStartedLoadingDataSource];
    }
    
    //
    
    self.isFetching = YES;
    
    NSBlockOperation * __block op = [NSBlockOperation new];
    
    [op addExecutionBlock:^{
       NSDictionary<NSString *, NSString *> *defaultOptions = BlizzardHSAPIDefaultOptions();
        
        if (options == nil) {
            [self->_options release];
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

- (void)resetDataSource{
    [self.queue cancelAllOperations];
    
    [self.queue addOperationWithBlock:^{
        self.pageCount = nil;
        self.page = [NSNumber numberWithUnsignedInt:1];
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        [snapshot deleteAllItems];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
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
        
        NSMutableArray<DeckAddCardItemModel *> *itemModels = [@[] mutableCopy];
        
        for (HSCard *card in cards) {
            DeckAddCardItemModel *itemModel = [[DeckAddCardItemModel alloc] initWithCard:card];
            [itemModels addObject:itemModel];
            [itemModel release];
        }
        
        [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:sectionModel];
        
        [itemModels release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
            completion();
            [self postEndedLoadingDataSource];
        }];
    }];
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

- (void)observePrefsChange {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(prefsChangedEventReceived:)
                                               name:NSNotificationNamePrefsUseCaseObserveData
                                             object:self.prefsUseCase];
}

- (void)prefsChangedEventReceived:(NSNotification *)notification {
    [self requestDataSourceWithOptions:self.options reset:YES];
}

- (void)observeDataCachesDeleted {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(dataCacheDeletedEventReceived:)
                                               name:NSNotificationNameDataCacheUseCaseDeleteAll
                                             object:nil];
}

- (void)dataCacheDeletedEventReceived:(NSNotification *)notification {
    [self requestDataSourceWithOptions:self.options reset:YES];
}

@end
