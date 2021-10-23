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
        self->_contextMenuIndexPath = nil;
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
        
        [self observePrefsChange];
        [self observeDataCachesDeleted];
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

- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *,id> * _Nullable)options reset:(BOOL)reset {
    
    if (reset) {
        [self resetDataSource];
    } else {
        if (self.isFetching) return NO;
        if (!self.canLoadMore) return NO;
    }
    
    //
    
    self.isFetching = YES;
    
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
    
    [self.hsCardUseCase fetchWithOptions:mutableDic completionHandler:^(NSArray<HSCard *> * _Nullable cards, NSNumber *pageCount, NSNumber *page, NSError * _Nullable error) {
        
        [mutableDic release];
        
        if (error) {
            [self postError:error];
        }
        
        [self.queue addBarrierBlock:^{
            self.pageCount = pageCount;
            self.page = page;
            self.isFetching = NO;
            [self updateDataSourceWithCards:cards];
        }];
    }];
    
    return YES;
}

- (void)resetDataSource {
    self.pageCount = nil;
    self.page = [NSNumber numberWithUnsignedInt:1];
    NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
    [snapshot deleteAllItems];
    
    [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:NO completion:^{
        [snapshot release];
        [self postApplyingSnapshotWasDone];
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

- (void)updateDataSourceWithCards:(NSArray<HSCard *> *)cards {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        CardSectionModel * _Nullable sectionModel = nil;
        
        for (CardSectionModel *tmp in snapshot.sectionIdentifiers) {
            if (tmp.type == CardSectionModelTypeCards) {
                sectionModel = tmp;
            }
        }
        
        if (sectionModel == nil) {
            sectionModel = [[[CardSectionModel alloc] initWithType:CardSectionModelTypeCards] autorelease];
            [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        }
        
        NSMutableArray<CardItemModel *> *itemModels = [@[] mutableCopy];
        
        for (HSCard *card in cards) {
            CardItemModel *itemModel = [[CardItemModel alloc] initWithCard:card];
            [itemModels addObject:itemModel];
            [itemModel release];
        }
        
        [snapshot appendItemsWithIdentifiers:[[itemModels copy] autorelease] intoSectionWithIdentifier:sectionModel];
        
        [itemModels release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
            [self postApplyingSnapshotWasDone];
        }];
    }];
}

- (void)postError:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:CardsViewModelErrorNotificationName
                                                      object:self
                                                    userInfo:@{CardsViewModelErrorNotificationErrorKey: error}];
}

- (void)postApplyingSnapshotWasDone {
    [NSNotificationCenter.defaultCenter postNotificationName:CardsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName
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
