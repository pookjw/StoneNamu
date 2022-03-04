//
//  CardsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "DragItemService.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface CardsViewModel ()
@property (retain) id<HSCardUseCase> hsCardUseCase;
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
        self.hsCardGameModeSlugType = nil;
        self.contextMenuIndexPath = nil;
        
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
        HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
        self.hsCardUseCase = hsCardUseCase;
        [hsCardUseCase release];
        
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
    }
    
    return self;
}

- (void)dealloc {
    [_hsCardGameModeSlugType release];
    [_contextMenuIndexPath release];
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

- (NSDictionary<NSString *, NSSet<NSString *> *> *)defaultOptions {
    return BlizzardHSAPIDefaultOptionsFromHSCardTypeSlugType(self.hsCardGameModeSlugType);
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
    
    self.isFetching = YES;
    
    NSBlockOperation * __block op = [NSBlockOperation new];
    
    [op addExecutionBlock:^{
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
        
        [self postStartedLoadingDataSource];
        
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

- (void)hsCardFromIndexPath:(NSIndexPath *)indexPath completion:(CardsViewModelHSCardFromIndexPathCompletion)completion {
    [self.queue addBarrierBlock:^{
        CardItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
        completion(itemModel.hsCard);
    }];
}

- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath image:(UIImage * _Nullable)image {
    CardItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) return @[];
    
    UIDragItem *dragItem = [DragItemService.sharedInstance makeDragItemsFromHSCard:itemModel.hsCard image:image];
    
    return @[dragItem];
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
        
        NSMutableArray<CardItemModel *> *itemModels = [NSMutableArray<CardItemModel *> new];
        
        for (HSCard *card in cards) {
            CardItemModel *itemModel = [[CardItemModel alloc] initWithHSCard:card hsCardGameModeSlugType:self.hsCardGameModeSlugType];
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

- (void)postStartedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardsViewModelStartedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postEndedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardsViewModelEndedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

@end
