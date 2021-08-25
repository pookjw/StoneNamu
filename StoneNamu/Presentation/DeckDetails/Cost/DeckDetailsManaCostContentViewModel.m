//
//  DeckDetailsManaCostContentViewModel.m
//  DeckDetailsManaCostContentViewModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckDetailsManaCostContentViewModel.h"

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
        
        NSUInteger __block highestCost = 0;
        
        [copyManaDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            highestCost = MAX(highestCost, obj.unsignedIntegerValue);
        }];
        
        for (NSUInteger i = 0; i < DeckDetailsManaCostContentViewModelCountOfData; i++) {
            @autoreleasepool {
                DeckDetailsManaCostContentItemModel *itemModel = [[DeckDetailsManaCostContentItemModel alloc] initWithType:DeckDetailsManaCostContentItemModelTypeCostGraph];
                NSNumber *cardManaCost = [NSNumber numberWithUnsignedInteger:i];
                
                itemModel.cardManaCost = cardManaCost;
                
                if ((copyManaDictionary[cardManaCost] == nil) || (highestCost == 0)) {
                    itemModel.percentage = [NSNumber numberWithFloat:0.f];
                } else {
                    itemModel.percentage = [NSNumber numberWithFloat:(copyManaDictionary[cardManaCost].floatValue / highestCost)];
                }
                
                [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                
                [itemModel release];
            }
        }
        
        [copyManaDictionary release];
        [sectionModel release];
        
        //
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
            }];
        }];
    }];
}

@end
