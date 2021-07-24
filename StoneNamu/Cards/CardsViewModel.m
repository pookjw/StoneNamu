//
//  CardsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardsViewModel.h"
#import "HSCardUseCaseImpl.h"

@interface CardsViewModel ()
@property (retain) NSObject<HSCardUseCase> *hsCardUseCase;
@end

@implementation CardsViewModel

- (instancetype)initWithDataSource:(CardsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        _dataSource = dataSource;
        [_dataSource retain];
        
        HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
        self.hsCardUseCase = hsCardUseCase;
        [hsCardUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_hsCardUseCase release];
    [super dealloc];
}

-(void)requestDataSourceWithOptions:(NSDictionary<NSString *,id> * _Nullable)options {
    [self.hsCardUseCase fetchWithOptions:options completionHandler:^(NSArray<HSCard *> * _Nullable cards, NSError * _Nullable error) {
        
        if (error) {
            [self postError:error];
        }
        
        [self updateDataSourceWithCards:cards];
    }];
}

- (void)updateDataSourceWithCards:(NSArray<HSCard *> *)cards {
    NSDiffableDataSourceSnapshot *snapshot = [self.dataSource snapshot];
    
    [snapshot deleteAllItems];
    
    CardsSectionModel *sectionModel = [[CardsSectionModel alloc] initWithType:CardsSectionModelTypeCards];
    
    [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
    
    NSMutableArray<CardsItemModel *> *itemModels = [@[] mutableCopy];
    
    for (HSCard *card in cards) {
        CardsItemModel *itemModel = [[CardsItemModel alloc] initWithCard:card];
        [itemModels addObject:itemModel];
        [itemModel release];
    }
    
    [snapshot appendItemsWithIdentifiers:[[itemModels copy] autorelease] intoSectionWithIdentifier:sectionModel];
    
    [sectionModel release];
    [itemModels release];
    
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

- (void)postError:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:CardsViewModelErrorNotification
                                                      object:self
                                                    userInfo:@{@"error": error}];
}

@end
