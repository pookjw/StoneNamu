//
//  DeckDetailsManaCostContentViewModel.m
//  DeckDetailsManaCostContentViewModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckDetailsManaCostContentViewModel.h"
#import "NSDiffableDataSourceSnapshot+sort.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface DeckDetailsManaCostContentViewModel ()
@property (retain) NSOperationQueue *queue;
@end

@implementation DeckDetailsManaCostContentViewModel

- (instancetype)initWithDataSource:(DeckDetailsManaCostContentDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self->_dataSource = [dataSource retain];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        self.queue = queue;
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        [queue release];
    }
    
    return self;
}

- (void)dealloc {
    [_queue release];
    [_dataSource release];
    [super dealloc];
}

- (void)requestDataSourceWithManaDictionary:(NSDictionary<NSNumber *,NSNumber *> *)manaDictionary {
    NSDictionary<NSNumber *, NSNumber *> *copyManaDictionary = [manaDictionary copy];
    
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        DeckDetailsManaCostContentSectionModel *sectionModel = [[DeckDetailsManaCostContentSectionModel alloc] initWithType:DeckDetailsManaCostContentSectionModelTypeNoName];
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        //
        
        NSMutableDictionary<NSNumber *, NSNumber *> *manaDictionaryWithPlus = [@{} mutableCopy];
        
        for (NSUInteger i = 0; i < DeckDetailsManaCostContentViewModelCountOfData; i++) {
            manaDictionaryWithPlus[[NSNumber numberWithUnsignedInteger:i]] = @0;
        }
        
        [copyManaDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            NSUInteger maxCost = DeckDetailsManaCostContentViewModelCountOfData - 1;
            
            if (key.unsignedIntegerValue >= maxCost) {
                NSNumber *maxCostNumber = [NSNumber numberWithUnsignedInteger:maxCost];
                
                if (manaDictionaryWithPlus[maxCostNumber] != nil) {
                    NSUInteger old = manaDictionaryWithPlus[maxCostNumber].unsignedIntegerValue;
                    NSUInteger new = old + obj.unsignedIntegerValue;
                    manaDictionaryWithPlus[maxCostNumber] = [NSNumber numberWithUnsignedInteger:new];
                } else {
                    manaDictionaryWithPlus[maxCostNumber] = obj;
                }
            } else {
                manaDictionaryWithPlus[key] = obj;
            }
        }];
        
        [copyManaDictionary release];
        
        //
        
        NSUInteger __block highestCostCount = 0;
        
        [manaDictionaryWithPlus enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            highestCostCount = MAX(highestCostCount, obj.unsignedIntegerValue);
        }];
        
        [manaDictionaryWithPlus enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            DeckDetailsManaCostContentItemModel *itemModel = [[DeckDetailsManaCostContentItemModel alloc] initWithType:DeckDetailsManaCostContentItemModelTypeCostGraph];
            itemModel.cardManaCost = key;
            
            if (highestCostCount == 0) {
                itemModel.percentage = [NSNumber numberWithFloat:0.f];
            } else {
                itemModel.percentage = [NSNumber numberWithFloat:(obj.floatValue / (float)highestCostCount)];
            }
            
            itemModel.cardCount = obj;
            
            [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
            [itemModel release];
        }];
        
        [manaDictionaryWithPlus release];
        [sectionModel release];
        
        //
        
        [self sortSnapshot:snapshot];
        
        //
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:NO completion:^{
            [snapshot release];
        }];
    }];
}

- (void)sortSnapshot:(NSDiffableDataSourceSnapshot *)snapshot {
    [snapshot sortItemsWithSectionIdentifiers:snapshot.sectionIdentifiers
                              usingComparator:^NSComparisonResult(DeckDetailsManaCostContentItemModel *obj1, DeckDetailsManaCostContentItemModel *obj2) {
        return [obj1.cardManaCost compare:obj2.cardManaCost];
    }];
}

@end
