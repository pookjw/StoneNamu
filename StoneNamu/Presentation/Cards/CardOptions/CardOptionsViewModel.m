//
//  CardOptionsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface CardOptionsViewModel ()
@property (retain) NSOperationQueue *queue;
@end

@implementation CardOptionsViewModel

- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
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

- (NSDictionary<NSString *, NSSet<NSString *> *> *)options {
    NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
    NSArray<CardOptionItemModel *> *itemModels = snapshot.itemIdentifiers;
    
    NSMutableDictionary<NSString *, NSSet<NSString *> *> *dic = [NSMutableDictionary<NSString *, NSSet<NSString *> *> new];
    
    [itemModels enumerateObjectsUsingBlock:^(CardOptionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSSet<NSString *> * _Nullable values = obj.values;
        
        if (values == nil) return;
        if (values.count == 0) return;
        
        BOOL __block hasEmptyValue = YES;
        
        [values enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            if (![obj isEqualToString:@""]) {
                hasEmptyValue = NO;
                *stop = YES;
            }
        }];
        
        if (!hasEmptyValue) {
            dic[BlizzardHSAPIOptionTypeFromCardOptionItemModelType(obj.type)] = values;
        }
    }];
    
    return [dic autorelease];
}

- (void)updateDataSourceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options {
    [self.queue addBarrierBlock:^{
        NSDictionary<NSString *, NSSet<NSString *> *> *nonnullOptions;
        
        if (options) {
            nonnullOptions = options;
        } else {
            nonnullOptions = @{};
        }
        
        //
        
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        NSMutableArray<CardOptionItemModel *> *toBeReconfiguredItemModels = [NSMutableArray<CardOptionItemModel *> new];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(CardOptionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = BlizzardHSAPIOptionTypeFromCardOptionItemModelType(obj.type);
            NSSet<NSString *> * _Nullable oldValues = obj.values;
            NSSet<NSString *> * _Nullable newValues = nonnullOptions[key];
            
            if ((oldValues == nil) && (newValues == nil)) {
                
            } else if (((oldValues == nil) && (newValues != nil)) || ((oldValues != nil) && (newValues == nil)) || (![oldValues isEqualToSet:newValues])) {
                obj.values = newValues;
                [toBeReconfiguredItemModels addObject:obj];
            }
        }];
        
        [snapshot reconfigureItemsWithIdentifiers:toBeReconfiguredItemModels];
        [toBeReconfiguredItemModels release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath {
    [self.queue addBarrierBlock:^{
        CardOptionItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromCardOptionItemModelType(itemModel.type);
        NSSet<NSString *> * _Nullable values = itemModel.values;
        
        switch (itemModel.valueSetType) {
            case CardOptionItemModelValueSetTypeTextField: {
                NSDictionary *userInfo;
                
                if ((values == nil) || (!values.hasValuesWhenStringType)) {
                    userInfo = @{CardOptionsViewModelPresentTextFieldOptionTypeItemKey: optionType};
                } else {
                    userInfo = @{CardOptionsViewModelPresentTextFieldOptionTypeItemKey: optionType,
                                 CardOptionsViewModelPresentTextFieldTextItemKey: values.allObjects.firstObject};
                }
                
                [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardOptionsViewModelPresentTextField
                                                                  object:self
                                                                userInfo:userInfo];
                break;
            }
            case CardOptionItemModelValueSetTypePicker: {
                NSDictionary *userInfo;
                
                if ((values == nil) || (!values.hasValuesWhenStringType)) {
                    userInfo = @{CardOptionsViewModelPresentPickerNotificationOptionTypeItemKey: optionType,
                                 CardOptionsViewModelPresentPickerNotificationShowEmptyRowItemKey: @NO};
                } else {
                    userInfo = @{CardOptionsViewModelPresentPickerNotificationOptionTypeItemKey: optionType,
                                 CardOptionsViewModelPresentPickerNotificationValuesItemKey: values,
                                 CardOptionsViewModelPresentPickerNotificationShowEmptyRowItemKey: @NO};
                }
                
                [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardOptionsViewModelPresentPicker
                                                                  object:self
                                                                userInfo:userInfo];
                break;
            }
            case CardOptionItemModelValueSetTypePickerWithEmptyRow: {
                NSDictionary *userInfo;
                
                if ((values == nil) || (!values.hasValuesWhenStringType)) {
                    userInfo = @{CardOptionsViewModelPresentPickerNotificationOptionTypeItemKey: optionType,
                                 CardOptionsViewModelPresentPickerNotificationShowEmptyRowItemKey: @YES};
                } else {
                    userInfo = @{CardOptionsViewModelPresentPickerNotificationOptionTypeItemKey: optionType,
                                 CardOptionsViewModelPresentPickerNotificationValuesItemKey: values,
                                 CardOptionsViewModelPresentPickerNotificationShowEmptyRowItemKey: @YES};
                }
                
                [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardOptionsViewModelPresentPicker
                                                                  object:self
                                                                userInfo:userInfo];
                break;
            }
            default:
                break;
        }
    }];
}

- (void)updateItem:(CardOptionItemModel *)itemModel withValues:(NSSet<NSString *> * _Nullable)values {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        itemModel.values = values;
        
        [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

- (void)updateOptionType:(BlizzardHSAPIOptionType)optionType withValues:(NSSet<NSString *> *)values {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        NSMutableArray<CardOptionItemModel *> *toBeReconfiguredItemModels = [NSMutableArray<CardOptionItemModel *> new];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(CardOptionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BlizzardHSAPIOptionType tmp = BlizzardHSAPIOptionTypeFromCardOptionItemModelType(obj.type);
            
            if ([tmp isEqualToString:optionType]) {
                NSSet<NSString *> * _Nullable oldValues = obj.values;
                NSSet<NSString *> * _Nullable newValues = values;
                
                if ((oldValues == nil) && (newValues == nil)) {
                    
                } else if (((oldValues == nil) && (newValues != nil)) || ((oldValues != nil) && (newValues == nil)) || (![oldValues isEqualToSet:newValues])) {
                    obj.values = newValues;
                    [toBeReconfiguredItemModels addObject:obj];
                }
            }
        }];
        
        [snapshot reconfigureItemsWithIdentifiers:toBeReconfiguredItemModels];
        [toBeReconfiguredItemModels release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
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
                [[[CardOptionItemModel alloc] initWithType:CardOptionItemModelTypeSpellSchool] autorelease],
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
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

@end
