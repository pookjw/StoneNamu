//
//  CardsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardsViewModel.h"
#import "HSCardUseCaseImpl.h"
#import "BlizzardHSAPIKeys.h"

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
        _dataSource = [dataSource retain];
        
        HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
        self.hsCardUseCase = hsCardUseCase;
        [hsCardUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        self.pageCount = nil;
        self.page = [NSNumber numberWithUnsignedInt:1];
        self.isFetching = NO;
    }
    
    return self;
}

- (void)requestDataSourceWithOptions:(NSDictionary<NSString *,id> * _Nullable)options {
    if (self.isFetching) return;
    if (!self.canLoadMore) return;
    
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

- (BOOL)canLoadMore {
    if (self.pageCount == nil) {
        return YES;
    }
    return ![self.pageCount isEqual:self.page];
}

- (void)dealloc {
    [_dataSource release];
    [_hsCardUseCase release];
    [_pageCount release];
    [_page release];
    [_queue cancelAllOperations];
    [_queue release];
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

- (void)updateDataSourceWithCards:(NSArray<HSCard *> *)cards {
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
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
        [snapshot release];
    }];
}

- (void)postError:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:CardsViewModelErrorNotificationName
                                                      object:self
                                                    userInfo:@{CardsViewModelErrorNotificationErrorKey: error}];
}

@end
