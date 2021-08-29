//
//  CardOptionsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsViewModel.h"
#import "BlizzardHSAPIKeys.h"
#import "NSSemaphoreCondition.h"

@interface CardOptionsViewModel ()
@property (retain) NSOperationQueue *queue;
@end

@implementation CardOptionsViewModel

- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        _dataSource = dataSource;
        [_dataSource retain];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        [self configureSnapshot];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_queue release];
    [super dealloc];
}

- (NSDictionary<NSString *,id> *)options {
    NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
    NSArray<CardOptionItemModel *> *itemModels = snapshot.itemIdentifiers;
    
    NSMutableDictionary *dic = [@{} mutableCopy];
    
    for (CardOptionItemModel *itemModel in itemModels) {
        if ((itemModel.value) && (![itemModel.value isEqualToString:@""])) {
            dic[NSStringFromCardOptionItemModelType(itemModel.type)] = itemModel.value;
        }
    }
    
    NSDictionary *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}

- (void)updateDataSourceWithOptions:(NSDictionary<NSString *,NSString *> * _Nullable)options {
    [self.queue addBarrierBlock:^{
        NSDictionary<NSString *, NSString *> *nonnullOptions;
        
        if (options) {
            nonnullOptions = [options copy];
        } else {
            nonnullOptions = [@{} retain];
        }
        
        //
        
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        NSArray<CardOptionItemModel *> *itemModels = snapshot.itemIdentifiers;
        
        for (CardOptionItemModel *itemModel in itemModels) {
            NSString *key = NSStringFromCardOptionItemModelType(itemModel.type);
            NSString * _Nullable value = nonnullOptions[key];
            itemModel.value = value;
            
            if (itemModel.value == nil) {
                itemModel.value = itemModel.defaultValue;
            }
        }
        
        [nonnullOptions release];
        [snapshot reconfigureItemsWithIdentifiers:itemModels];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
            }];
        }];
    }];
}

- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath {
    CardOptionItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    switch (itemModel.valueSetType) {
        case CardOptionItemModelValueSetTypeTextField:
            [NSNotificationCenter.defaultCenter postNotificationName:CardOptionsViewModelPresentTextFieldNotificationName
                                                              object:self
                                                            userInfo:@{
                CardOptionsViewModelPresentNotificationItemKey: itemModel
            }];
            break;
        case CardOptionItemModelValueSetTypePicker:
            [NSNotificationCenter.defaultCenter postNotificationName:CardOptionsViewModelPresentPickerNotificationName
                                                              object:self
                                                            userInfo:@{
                CardOptionsViewModelPresentNotificationItemKey: itemModel,
                CardOptionsViewModelPresentPickerNotificationShowEmptyRowKey: [NSNumber numberWithBool:NO]
            }];
            break;
        case CardOptionItemModelValueSetTypePickerWithEmptyRow:
            [NSNotificationCenter.defaultCenter postNotificationName:CardOptionsViewModelPresentPickerNotificationName
                                                              object:self
                                                            userInfo:@{
                CardOptionsViewModelPresentNotificationItemKey: itemModel,
                CardOptionsViewModelPresentPickerNotificationShowEmptyRowKey: [NSNumber numberWithBool:YES]
            }];
            break;
        case CardOptionItemModelValueSetTypeStepper: {
            [NSNotificationCenter.defaultCenter postNotificationName:CardOptionsViewModelPresentStepperNotificationName
                                                              object:self
                                                            userInfo:@{
                CardOptionsViewModelPresentNotificationItemKey: itemModel
            }];
        }
        default:
            break;
    }
}

- (void)updateItem:(CardOptionItemModel *)itemModel withValue:(NSString * _Nullable)value {
    [itemModel retain];
    [value retain];
    
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
        itemModel.value = value;
        
        [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
        }];
        
        [itemModel release];
        [value release];
    }];
}

- (void)configureSnapshot {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        CardOptionSectionModel *cardSectionModel = [[CardOptionSectionModel alloc] initWithType:CardOptionSectionModelTypeCard];
        CardOptionSectionModel *sortSectionModel = [[CardOptionSectionModel alloc] initWithType:CardOptionSectionModelTypeSort];
        
        [snapshot appendSectionsWithIdentifiers:@[cardSectionModel, sortSectionModel]];
        
        @autoreleasepool {
            [snapshot appendItemsWithIdentifiers:@[
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeSet] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeClass] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeManaCost] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeAttack] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeHealth] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeCollectible] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeRarity] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeType] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeMinionType] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeKeyword] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeTextFilter] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeGameMode] autorelease]
            ]
                       intoSectionWithIdentifier:cardSectionModel];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeSort] autorelease]
            ]
                       intoSectionWithIdentifier:sortSectionModel];
        }
        
        [cardSectionModel release];
        [sortSectionModel release];
        
        NSSemaphoreCondition *semaphore = [NSSemaphoreCondition new];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [semaphore signal];
                [snapshot release];
            }];
        }];
        
        [semaphore wait];
        [semaphore release];
    }];
}

@end
