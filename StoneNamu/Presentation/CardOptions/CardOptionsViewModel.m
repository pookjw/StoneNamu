//
//  CardOptionsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsViewModel.h"
#import "BlizzardHSAPIKeys.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

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
        }
        
        [nonnullOptions release];
        [snapshot reconfigureItemsWithIdentifiers:itemModels];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
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
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        itemModel.value = value;
        
        [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
        }];
        
        [itemModel release];
        [value release];
    }];
}

- (void)configureSnapshot {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        CardOptionSectionModel *firstSectionModel = [[CardOptionSectionModel alloc] initWithType:CardOptionSectionModelTypeFirst];
        CardOptionSectionModel *secondSectionModel = [[CardOptionSectionModel alloc] initWithType:CardOptionSectionModelTypeSecond];
        CardOptionSectionModel *thirdSectionModel = [[CardOptionSectionModel alloc] initWithType:CardOptionSectionModelTypeThird];
        CardOptionSectionModel *forthSectionModel = [[CardOptionSectionModel alloc] initWithType:CardOptionSectionModelTypeForth];
        CardOptionSectionModel *fifthSectionModel = [[CardOptionSectionModel alloc] initWithType:CardOptionSectionModelTypeFifth];
        
        [snapshot appendSectionsWithIdentifiers:@[firstSectionModel, secondSectionModel, thirdSectionModel, forthSectionModel, fifthSectionModel]];
        
        @autoreleasepool {
            [snapshot appendItemsWithIdentifiers:@[
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeTextFilter] autorelease]
            ]
                       intoSectionWithIdentifier:firstSectionModel];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeSet] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeClass] autorelease]
            ]
                       intoSectionWithIdentifier:secondSectionModel];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeManaCost] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeAttack] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeHealth] autorelease],
            ]
                       intoSectionWithIdentifier:thirdSectionModel];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeCollectible] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeRarity] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeType] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeMinionType] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeKeyword] autorelease],
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeGameMode] autorelease]
            ]
                       intoSectionWithIdentifier:forthSectionModel];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeSort] autorelease]
            ]
                       intoSectionWithIdentifier:fifthSectionModel];
        }
        
        [firstSectionModel release];
        [secondSectionModel release];
        [thirdSectionModel release];
        [forthSectionModel release];
        [fifthSectionModel release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
        }];
    }];
}

@end
