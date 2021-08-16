//
//  CardsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardsViewModel.h"
#import "HSCardUseCaseImpl.h"
#import "BlizzardHSAPIKeys.h"
#import "NSSemaphoreCondition.h"

@interface CardsViewModel ()
@property (retain) id<HSCardUseCase> hsCardUseCase;
@property (retain) NSNumber * _Nullable pageCount;
@property (retain) NSNumber *page;
@property (nonatomic, readonly) BOOL canLoadMore;
@property BOOL isFetching;
@property (retain) NSOperationQueue *queue;
@end

@implementation CardsViewModel

- (instancetype)initWithDataSource:(CardsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        _contextMenuIndexPath = nil;
        _dataSource = [dataSource retain];
        
        HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
        self.hsCardUseCase = hsCardUseCase;
        [hsCardUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        self.options = nil;
        
        self.pageCount = nil;
        self.page = [NSNumber numberWithUnsignedInt:1];
        self.isFetching = NO;
    }
    
    return self;
}

- (void)requestDataSourceWithOptions:(NSDictionary<NSString *,id> * _Nullable)options reset:(BOOL)reset {
    
    if (reset) {
        [self resetDataSource];
    } else {
        if (self.isFetching) return;
        if (!self.canLoadMore) return;
    }
    
    //
    
    self.isFetching = YES;
    
    NSMutableDictionary *mutableDic = [options mutableCopy];
    
    if (self.pageCount != nil) {
        // Next page
        NSNumber *nextPage = [NSNumber numberWithUnsignedInt:[self.page unsignedIntValue] + 1];
        mutableDic[BlizzardHSAPIOptionTypePage] = [nextPage stringValue];
    } else {
        // Initial data
        mutableDic[BlizzardHSAPIOptionTypePage] = [self.page stringValue];
    }
    
    NSDictionary *finalDic = [[mutableDic copy] autorelease];
    [mutableDic release];
    
    [self.hsCardUseCase fetchWithOptions:finalDic completionHandler:^(NSArray<HSCard *> * _Nullable cards, NSNumber *pageCount, NSNumber *page, NSError * _Nullable error) {
        
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
}

- (void)resetDataSource {
    self.page = @1;
    self.pageCount = nil;
    NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
    [snapshot deleteAllItems];
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.dataSource applySnapshot:snapshot animatingDifferences:NO];
        [snapshot release];
    }];
}

- (BOOL)canLoadMore {
    if (self.pageCount == nil) {
        return YES;
    }
    return ![self.pageCount isEqual:self.page];
}

- (void)dealloc {
    [_contextMenuIndexPath release];
    [_dataSource release];
    [_hsCardUseCase release];
    [_pageCount release];
    [_page release];
    [_queue cancelAllOperations];
    [_queue release];
    [_options release];
    [super dealloc];
}

- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath {
    CardItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    HSCard *hsCard = itemModel.card;
    
    [NSNotificationCenter.defaultCenter postNotificationName:CardsViewModelPresentDetailNotificationName
                                                      object:self
                                                    userInfo:@{
        CardsViewModelPresentDetailNotificationHSCardKey: hsCard,
        CardsViewModelPresentDetailNotificationIndexPathKey: indexPath
    }];
}

- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath image:(UIImage * _Nullable)image {
    CardItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) return @[];
    
    NSItemProvider *itemProvider;
    
    if (image) {
        itemProvider = [[NSItemProvider alloc] initWithObject:image];
    } else {
        itemProvider = [NSItemProvider new];
    }
    
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    [itemProvider release];
    
    dragItem.localObject = itemModel.card;
    
    return @[dragItem];
}

- (void)updateDataSourceWithCards:(NSArray<HSCard *> *)cards {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        CardSectionModel * _Nullable sectionModel = nil;
        
        for (CardSectionModel *tmp in snapshot.sectionIdentifiers) {
            if (tmp.type == CardsSectionModelTypeCards) {
                sectionModel = tmp;
            }
        }
        
        if (sectionModel == nil) {
            sectionModel = [[[CardSectionModel alloc] initWithType:CardsSectionModelTypeCards] autorelease];
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
        
        NSSemaphoreCondition *semaphore = [NSSemaphoreCondition new];
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [semaphore signal];
            }];
            [snapshot release];
        }];
        
        [semaphore wait];
        [semaphore release];
    }];
}

- (void)postError:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:CardsViewModelErrorNotificationName
                                                      object:self
                                                    userInfo:@{CardsViewModelErrorNotificationErrorKey: error}];
}

@end
