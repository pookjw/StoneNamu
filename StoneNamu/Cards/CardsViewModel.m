//
//  CardsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardsViewModel.h"
#import "HSCardUseCaseImpl.h"

@interface CardsViewModel ()
@property (retain) id<HSCardUseCase> fetchHSCardUseCase;
@property (retain) NSOperationQueue *queue;
@end

@implementation CardsViewModel

- (instancetype)initWithDataSource:(CardsDataSource *)dataSource options:(NSDictionary<NSString *, id> *)options {
    self = [self init];
    
    if (self) {
        _dataSource = dataSource;
        [_dataSource retain];
        
        HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
        self.fetchHSCardUseCase = hsCardUseCase;
        [hsCardUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        _queue = queue;
        
        [self requestDataSourceWithOptions:options];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_fetchHSCardUseCase release];
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

-(void)requestDataSourceWithOptions:(NSDictionary<NSString *,id> * _Nullable)options {
    [self.fetchHSCardUseCase fetchWithOptions:options completionHandler:^(NSArray<HSCard *> * _Nullable cards, NSError * _Nullable error) {
        
        if (error) {
            [self postError:error];
        }
        
        [self.queue addOperationWithBlock:^{
            [self updateDataSourceWithCards:cards];
        }];
    }];
}

- (void)updateDataSourceWithCards:(NSArray<HSCard *> *)cards {
    NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
    
    [snapshot deleteAllItems];
    
    CardSectionModel *sectionModel = [[CardSectionModel alloc] initWithType:CardsSectionModelTypeCards];
    [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
    
    NSMutableArray<CardItemModel *> *itemModels = [@[] mutableCopy];
    
    for (HSCard *card in cards) {
        CardItemModel *itemModel = [[CardItemModel alloc] initWithCard:card];
        [itemModels addObject:itemModel];
        [itemModel release];
    }
    
    [snapshot appendItemsWithIdentifiers:[[itemModels copy] autorelease] intoSectionWithIdentifier:sectionModel];
    [sectionModel release];
    
    [itemModels release];
    
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

- (void)postError:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:CardsViewModelErrorNotificationName
                                                      object:self
                                                    userInfo:@{CardsViewModelErrorNotificationErrorKey: error}];
}

@end
