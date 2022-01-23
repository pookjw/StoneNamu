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
        [self->_contextMenuIndexPath release];
        self->_contextMenuIndexPath = nil;
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
        
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
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

- (NSDictionary<NSString *,NSString *> *)defaultOptions {
    return BlizzardHSAPIDefaultOptions();
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
        NSMutableDictionary<NSString *, NSString *> *mutableOptions = [options mutableCopy];
        
        if (options == nil) {
            mutableOptions = [defaultOptions mutableCopy];
            
            [self->_options release];
            self->_options = [mutableOptions copy];
        } else {
            for (NSString *key in defaultOptions.allKeys) {
                if (mutableOptions[key] == nil) {
                    mutableOptions[key] = defaultOptions[key];
                }
            }
            
            [self->_options release];
            self->_options = [mutableOptions copy];
        }
        
        //
        
        [self postStartedLoadingDataSource];
        
        //
        
        if (self.pageCount != nil) {
            // Next page
            NSNumber *nextPage = [NSNumber numberWithUnsignedInt:[self.page unsignedIntValue] + 1];
            mutableOptions[BlizzardHSAPIOptionTypePage] = [nextPage stringValue];
        } else {
            // Initial data
            mutableOptions[BlizzardHSAPIOptionTypePage] = [self.page stringValue];
        }
        
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:0];
        
        [self.hsCardUseCase fetchWithOptions:mutableOptions completionHandler:^(NSArray<HSCard *> * _Nullable cards, NSNumber *pageCount, NSNumber *page, NSError * _Nullable error) {
            
            [mutableOptions release];
            
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
