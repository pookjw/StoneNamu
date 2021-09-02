//
//  DeckAddCardOptionsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "DeckAddCardOptionsViewModel.h"
#import "BlizzardHSAPIKeys.h"
#import "NSSemaphoreCondition.h"

@interface DeckAddCardOptionsViewModel ()
@property (retain) NSOperationQueue *queue;
@end

@implementation DeckAddCardOptionsViewModel

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
    NSArray<DeckAddCardOptionItemModel *> *itemModels = snapshot.itemIdentifiers;
    
    NSMutableDictionary *dic = [@{} mutableCopy];
    
    for (DeckAddCardOptionItemModel *itemModel in itemModels) {
        if ((itemModel.value) && (![itemModel.value isEqualToString:@""])) {
            dic[NSStringFromDeckAddCardOptionItemModelType(itemModel.type)] = itemModel.value;
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
        NSArray<DeckAddCardOptionItemModel *> *itemModels = snapshot.itemIdentifiers;
        
        for (DeckAddCardOptionItemModel *itemModel in itemModels) {
            NSString *key = NSStringFromDeckAddCardOptionItemModelType(itemModel.type);
            NSString * _Nullable value = nonnullOptions[key];
            itemModel.value = value;
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
    DeckAddCardOptionItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    switch (itemModel.valueSetType) {
        case DeckAddCardOptionItemModelValueSetTypeTextField:
            [NSNotificationCenter.defaultCenter postNotificationName:DeckAddCardOptionsViewModelPresentTextFieldNotificationName
                                                              object:self
                                                            userInfo:@{
                DeckAddCardOptionsViewModelPresentNotificationItemKey: itemModel
            }];
            break;
        case DeckAddCardOptionItemModelValueSetTypePicker:
            [NSNotificationCenter.defaultCenter postNotificationName:DeckAddCardOptionsViewModelPresentPickerNotificationName
                                                              object:self
                                                            userInfo:@{
                DeckAddCardOptionsViewModelPresentNotificationItemKey: itemModel,
                DeckAddCardOptionsViewModelPresentPickerNotificationShowEmptyRowKey: [NSNumber numberWithBool:NO]
            }];
            break;
        case DeckAddCardOptionItemModelValueSetTypePickerWithEmptyRow:
            [NSNotificationCenter.defaultCenter postNotificationName:DeckAddCardOptionsViewModelPresentPickerNotificationName
                                                              object:self
                                                            userInfo:@{
                DeckAddCardOptionsViewModelPresentNotificationItemKey: itemModel,
                DeckAddCardOptionsViewModelPresentPickerNotificationShowEmptyRowKey: [NSNumber numberWithBool:YES]
            }];
            break;
        case DeckAddCardOptionItemModelValueSetTypeStepper: {
            [NSNotificationCenter.defaultCenter postNotificationName:DeckAddCardOptionsViewModelPresentStepperNotificationName
                                                              object:self
                                                            userInfo:@{
                DeckAddCardOptionsViewModelPresentNotificationItemKey: itemModel
            }];
        }
        default:
            break;
    }
}

- (void)updateItem:(DeckAddCardOptionItemModel *)itemModel withValue:(NSString * _Nullable)value {
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
        
        DeckAddCardOptionSectionModel *majorSectionModel = [[DeckAddCardOptionSectionModel alloc] initWithType:DeckAddCardOptionSectionModelTypeMajor];
        DeckAddCardOptionSectionModel *minorSectionModel = [[DeckAddCardOptionSectionModel alloc] initWithType:DeckAddCardOptionSectionModelTypeMinor];
        
        [snapshot appendSectionsWithIdentifiers:@[majorSectionModel, minorSectionModel]];
        
        @autoreleasepool {
            [snapshot appendItemsWithIdentifiers:@[
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeSet] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeClass] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeManaCost] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeAttack] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeHealth] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeCollectible] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeRarity] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeType] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeMinionType] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeKeyword] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeTextFilter] autorelease]
            ]
                       intoSectionWithIdentifier:majorSectionModel];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeGameMode] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeSort] autorelease]
            ]
                       intoSectionWithIdentifier:minorSectionModel];
        }
        
        [majorSectionModel release];
        [minorSectionModel release];
        
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
