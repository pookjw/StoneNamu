//
//  CardOptionsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "PickerSectionModel.h"
#import "PickerItemModel.h"

@interface CardOptionsViewModel ()
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@property (retain) NSOperationQueue *queue;
@end

@implementation CardOptionsViewModel

- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self.contextMenuIndexPath = nil;
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        [self configureSnapshot];
    }
    
    return self;
}

- (void)dealloc {
    [_contextMenuIndexPath release];
    [_dataSource release];
    [_hsMetaDataUseCase release];
    [_queue release];
    [super dealloc];
}

- (NSDictionary<NSString *, NSSet<NSString *> *> *)options {
    NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
    NSArray<CardOptionItemModel *> *itemModels = snapshot.itemIdentifiers;
    
    NSMutableDictionary<NSString *, NSSet<NSString *> *> *dic = [NSMutableDictionary<NSString *, NSSet<NSString *> *> new];
    
    [itemModels enumerateObjectsUsingBlock:^(CardOptionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSSet<NSString *> * _Nullable values = obj.values;
        
        BOOL hasValues;
        
        if ((values == nil) || (!values.hasValuesWhenStringType)) {
            hasValues = NO;
        } else {
            hasValues = YES;
        }
        
        if (!hasValues) {
            return;
        }
        
        dic[obj.optionType] = values;
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
            BlizzardHSAPIOptionType optionType = obj.optionType;
            NSSet<NSString *> * _Nullable oldValues = obj.values;
            NSSet<NSString *> * _Nullable newValues = nonnullOptions[optionType];
            
            if (!compareNullableValues(oldValues, newValues, @selector(isEqualToSet:))) {
                obj.values = newValues;
                
                //
                
                if ([BlizzardHSAPIOptionTypeTextFilter isEqualToString:obj.optionType]) {
                    obj.accessoryText = newValues.allObjects.firstObject;
                } else {
                    NSMutableArray<NSString *> *texts = [NSMutableArray<NSString *> new];
                    
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES comparator:obj.comparator];
                    NSArray<NSString *> *sortedValues = [newValues sortedArrayUsingDescriptors:@[sortDescriptor]];
                    
                    NSDictionary<NSString *, NSString *> *allSlugsAndNames = obj.allSlugsAndNames;
                    
                    [sortedValues enumerateObjectsUsingBlock:^(NSString * _Nonnull value, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString * _Nullable text = allSlugsAndNames[value];
                        
                        if (text == nil) {
                            text = value;
                        }
                        
                        [texts addObject:text];
                    }];
                    
                    obj.accessoryText = [texts componentsJoinedByString:@", "];
                    [texts release];
                }
                
                //
                
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
        
        if ([itemModel.optionType isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
            NSMutableDictionary *userInfo = [NSMutableDictionary new];
            
            userInfo[CardOptionsViewModelPresentTextFieldOptionTypeItemKey] = itemModel.optionType;
            
            if ([itemModel.values hasValuesWhenStringType]) {
                userInfo[CardOptionsViewModelPresentTextFieldTextItemKey] = itemModel.values.allObjects.firstObject;
            }
            
            userInfo[CardOptionsViewModelPresentTextFieldIndexPathItemKey] = indexPath;
            
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardOptionsViewModelPresentTextField
                                                              object:self
                                                            userInfo:userInfo];
            
            [userInfo release];
        } else {
            NSMutableDictionary<PickerSectionModel *, NSSet<PickerItemModel *> *> *pickers = [NSMutableDictionary<PickerSectionModel *, NSSet<PickerItemModel *> *> new];
            
            if (itemModel.showsEmptyRow) {
                PickerSectionModel *emptySectionModel = [[PickerSectionModel alloc] initWithType:1 << 0 title:nil];
                
                NSSet<NSString *> * _Nullable values = itemModel.values;
                BOOL hasValues;
                
                if (values) {
                    hasValues = values.hasValuesWhenStringType;
                } else {
                    hasValues = NO;
                }
                
                PickerItemModel *emptyItemModel = [[PickerItemModel alloc] initEmptyWithSectionType:1 << 0 IsSelected:!hasValues];
                
                pickers[emptySectionModel] = [NSSet setWithObject:emptyItemModel];
                
                [emptySectionModel release];
                [emptyItemModel release];
            }
            
            //
            
            [itemModel.slugsAndNames enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key1, NSDictionary<NSString *,NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
                NSMutableSet<PickerItemModel *> * _Nullable __block items = nil;
                
                [obj enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key2, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                    if (items == nil) {
                        items = [NSMutableSet<PickerItemModel *> new];
                    }
                    
                    NSSet<NSString *> * _Nullable values = itemModel.values;
                    BOOL isSelected;
                    
                    if (values) {
                        isSelected = [values containsObject:key2];
                    } else {
                        isSelected = NO;
                    }
                    
                    PickerItemModel *itemModel = [[PickerItemModel alloc] initWithSectionType:key1.unsignedIntValue key:key2 text:obj isSelected:isSelected];
                    [items addObject:itemModel];
                    [itemModel release];
                }];
                
                if (items) {
                    PickerSectionModel *sectionModel = [[PickerSectionModel alloc] initWithType:key1.unsignedIntValue title:itemModel.sectionHeaderTexts[key1]];
                    pickers[sectionModel] = items;
                    [sectionModel release];
                }
                
                [items release];
            }];
            
            //
            
            NSMutableDictionary *userInfo = [NSMutableDictionary new];
            
            userInfo[CardOptionsViewModelPresentPickerNotificationTitleItemKey] = [ResourcesService localizationForBlizzardHSAPIOptionType:itemModel.optionType];
            userInfo[CardOptionsViewModelPresentPickerNotificationOptionTypeItemKey] = itemModel.optionType;
            userInfo[CardOptionsViewModelPresentPickerNotificationPickersItemKey] = pickers;
            userInfo[CardOptionsViewModelPresentPickerNotificationAllowsMultipleSelectionItemKey] = [NSNumber numberWithBool:itemModel.allowsMultipleSelection];
            userInfo[CardOptionsViewModelPresentPickerNotificationComparatorItemKey] = itemModel.comparator;
            
            [pickers release];
            
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardOptionsViewModelPresentPicker
                                                              object:self
                                                            userInfo:userInfo];
            
            [userInfo release];
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
            BlizzardHSAPIOptionType tmp = obj.optionType;
            
            if ([tmp isEqualToString:optionType]) {
                NSSet<NSString *> * _Nullable oldValues = obj.values;
                NSSet<NSString *> * _Nullable newValues = values;
                
                if (!compareNullableValues(oldValues, newValues, @selector(isEqualToSet:))) {
                    obj.values = newValues;
                    [toBeReconfiguredItemModels addObject:obj];
                }
            }
        }];
        
        if (toBeReconfiguredItemModels.count == 0) {
            [toBeReconfiguredItemModels release];
            [snapshot release];
            return;
        }
        
        //
        
        [toBeReconfiguredItemModels enumerateObjectsUsingBlock:^(CardOptionItemModel * _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([BlizzardHSAPIOptionTypeTextFilter isEqualToString:obj1.optionType]) {
                obj1.accessoryText = obj1.values.allObjects.firstObject;
            } else {
                NSMutableArray<NSString *> *texts = [NSMutableArray<NSString *> new];
                
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES comparator:obj1.comparator];
                NSArray<NSString *> *sortedValues = [obj1.values sortedArrayUsingDescriptors:@[sortDescriptor]];
                
                NSDictionary<NSString *, NSString *> *allSlugsAndNames = obj1.allSlugsAndNames;
                
                [sortedValues enumerateObjectsUsingBlock:^(NSString * _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString * _Nullable text = allSlugsAndNames[obj2];

                    if (text == nil) {
                        text = obj2;
                    }

                    [texts addObject:text];
                }];
                
                obj1.accessoryText = [texts componentsJoinedByString:@", "];
                [texts release];
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
        [self postStaredLoadingDataSource];
        
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:0];
        HSMetaData * _Nullable __block hsMetaData = nil;
        
        [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable _hsMetaData, NSError * _Nullable error) {
            if (error) {
                [self postError:error];
                [semaphore signal];
                return;
            }
            
            hsMetaData = [_hsMetaData copy];
            [semaphore signal];
        }];
        
        [semaphore wait];
        [semaphore release];
        
        if (hsMetaData == nil) {
            [hsMetaData release];
            [self postEndedLoadingDataSource];
            return;
        }
        
        //
        
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        CardOptionSectionModel *firstSectionModel = [[CardOptionSectionModel alloc] initWithType:CardOptionSectionModelTypeFirst];
        CardOptionSectionModel *secondSectionModel = [[CardOptionSectionModel alloc] initWithType:CardOptionSectionModelTypeSecond];
        CardOptionSectionModel *thirdSectionModel = [[CardOptionSectionModel alloc] initWithType:CardOptionSectionModelTypeThird];
        CardOptionSectionModel *forthSectionModel = [[CardOptionSectionModel alloc] initWithType:CardOptionSectionModelTypeForth];
        CardOptionSectionModel *fifthSectionModel = [[CardOptionSectionModel alloc] initWithType:CardOptionSectionModelTypeFifth];
        
        //
        
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *optionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:nil withClassId:nil usingHSMetaData:hsMetaData];
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *optionTypesAndSlugsAndIds = [self.hsMetaDataUseCase optionTypesAndSlugsAndIdsFromHSDeckFormat:nil withClassId:nil usingHSMetaData:hsMetaData];
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *classicOptionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:HSDeckFormatClassic withClassId:nil usingHSMetaData:hsMetaData];
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *standardOptionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:HSDeckFormatStandard withClassId:nil usingHSMetaData:hsMetaData];
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *wildOptionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:HSDeckFormatWild withClassId:nil usingHSMetaData:hsMetaData];
        NSDictionary<NSString *, NSString *> *slugsAndNumberNames = @{@"0": @"0",
                                                                      @"1": @"1",
                                                                      @"2": @"2",
                                                                      @"3": @"3",
                                                                      @"4": @"4",
                                                                      @"5": @"5",
                                                                      @"6": @"6",
                                                                      @"7": @"7",
                                                                      @"8": @"8",
                                                                      @"9": @"9",
                                                                      @"10": @"10+"};
        
        //

        NSDictionary<NSString *, NSString *> *classicSetSlugsAndNames = classicOptionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSet];
        NSMutableDictionary<NSString *, NSString *> *standardSetSlugsAndNames = [standardOptionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSet] mutableCopy];
        NSMutableDictionary<NSString *, NSString *> *wildSetSlugsAndNames = [wildOptionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSet] mutableCopy];
        
        [standardSetSlugsAndNames.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [wildSetSlugsAndNames removeObjectForKey:obj];
        }];
        
        standardSetSlugsAndNames[HSCardSetSlugTypeStandardCards] = [ResourcesService localizationForHSDeckFormat:HSDeckFormatStandard];
        wildSetSlugsAndNames[HSCardSetSlugTypeWildCards] = [ResourcesService localizationForHSDeckFormat:HSDeckFormatWild];
        
        NSMutableDictionary<NSString *, NSNumber *> *setSlugsAndIds = [optionTypesAndSlugsAndIds[BlizzardHSAPIOptionTypeSet] mutableCopy];
        setSlugsAndIds[HSCardSetSlugTypeStandardCards] = [NSNumber numberWithUnsignedInteger:HSCardSetIdTypeStandardCards];
        setSlugsAndIds[HSCardSetSlugTypeWildCards] = [NSNumber numberWithUnsignedInteger:HSCardSetIdTypeWildCards];
        
        CardOptionItemModel *setItem = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeSet
                                                                         slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: classicSetSlugsAndNames,
                                                                                         [NSNumber numberWithUnsignedInt:1 << 2]: standardSetSlugsAndNames,
                                                                                         [NSNumber numberWithUnsignedInt:1 << 3]: wildSetSlugsAndNames
                                                                                       }
                                                                    sectionHeaderTexts:@{[NSNumber numberWithUnsignedInt:1 << 1]: [ResourcesService localizationForHSDeckFormat:HSDeckFormatClassic],
                                                                                         [NSNumber numberWithUnsignedInt:1 << 2]: [ResourcesService localizationForHSDeckFormat:HSDeckFormatStandard],
                                                                                         [NSNumber numberWithUnsignedInt:1 << 3]: [ResourcesService localizationForHSDeckFormat:HSDeckFormatWild]
                                                                                       }
                                                                         showsEmptyRow:YES
                                                               allowsMultipleSelection:NO
                                                                            comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = setSlugsAndIds[lhs];
            NSNumber *rhsNumber = setSlugsAndIds[rhs];
            return [rhsNumber compare:lhsNumber];
        }
                                                                                 title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeSet]
                                                                          accessoryText:nil
                                                                               toolTip:[ResourcesService localizationForKey:LocalizableKeyCardSetTooltipDescription]];
        
        [standardSetSlugsAndNames release];
        [wildSetSlugsAndNames release];
        [setSlugsAndIds release];
        
        //
        
        CardOptionItemModel *classItem = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeClass
                                                                           slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeClass]}
                                                                      sectionHeaderTexts:nil
                                                                           showsEmptyRow:YES
                                                                 allowsMultipleSelection:YES
                                                                            comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeClass][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeClass][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                 title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeClass]
                                                                            accessoryText:nil
                                                                               toolTip:[ResourcesService localizationForKey:LocalizableKeyCardClassTooltipDescription]];
        
        CardOptionItemModel *manaCostItem = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeManaCost
                                                                              slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: slugsAndNumberNames}
                                                                         sectionHeaderTexts:nil
                                                                              showsEmptyRow:YES
                                                                    allowsMultipleSelection:YES
                                                                                 comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:lhs.integerValue];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:rhs.integerValue];
            return [lhsNumber compare:rhsNumber];
        }
                                                                                      title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeManaCost]
                                                                               accessoryText:nil
                                                                                    toolTip:[ResourcesService localizationForKey:LocalizableKeyCardManaCostTooltipDescription]];
        
        CardOptionItemModel *attackItem = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeAttack
                                                                            slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: slugsAndNumberNames}
                                                                       sectionHeaderTexts:nil
                                                                            showsEmptyRow:YES
                                                                  allowsMultipleSelection:YES
                                                                                 comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:lhs.integerValue];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:rhs.integerValue];
            return [lhsNumber compare:rhsNumber];
        }
                                                                                      title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeAttack]
                                                                             accessoryText:nil
                                                                                    toolTip:[ResourcesService localizationForKey:LocalizableKeyCardAttackTooltipDescription]];
        
        CardOptionItemModel *healthItem = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeHealth
                                                                            slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: slugsAndNumberNames}
                                                                       sectionHeaderTexts:nil
                                                                            showsEmptyRow:YES
                                                                  allowsMultipleSelection:YES
                                                                                 comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:lhs.integerValue];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:rhs.integerValue];
            return [lhsNumber compare:rhsNumber];
        }
                                                                                      title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeHealth]
                                                                             accessoryText:nil
                                                                                    toolTip:[ResourcesService localizationForKey:LocalizableKeyCardHealthTooltipDescription]];
        
        CardOptionItemModel *collectibleItem = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeCollectible
                                                                                 slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: [ResourcesService localizationsForHSCardCollectible]}
                                                                            sectionHeaderTexts:nil
                                                                                 showsEmptyRow:NO
                                                                       allowsMultipleSelection:NO
                                                                                    comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:HSCardCollectibleFromNSString(lhs)];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:HSCardCollectibleFromNSString(rhs)];
            return [lhsNumber compare:rhsNumber];
        }
                                                                                         title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeCollectible]
                                                                                  accessoryText:nil
                                                                                       toolTip:[ResourcesService localizationForKey:LocalizableKeyCardCollectibleTooltipDescription]];
        
        CardOptionItemModel *rarityItem = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeRarity
                                                                            slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeRarity]}
                                                                       sectionHeaderTexts:nil
                                                                            showsEmptyRow:YES
                                                                  allowsMultipleSelection:YES
                                                                               comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = optionTypesAndSlugsAndIds[BlizzardHSAPIOptionTypeRarity][lhs];
            NSNumber *rhsNumber = optionTypesAndSlugsAndIds[BlizzardHSAPIOptionTypeRarity][rhs];
            return [lhsNumber compare:rhsNumber];
        }
                                                                                    title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeRarity]
                                                                             accessoryText:nil
                                                                                  toolTip:[ResourcesService localizationForKey:LocalizableKeyCardRarityTooltipDescription]];
        
        CardOptionItemModel *typeItem = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeType
                                                                          slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeType]}
                                                                     sectionHeaderTexts:nil
                                                                          showsEmptyRow:YES
                                                                allowsMultipleSelection:YES
                                                                             comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeType][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeType][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                  title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeType]
                                                                           accessoryText:nil
                                                                                toolTip:[ResourcesService localizationForKey:LocalizableKeyCardTypeTooltipDescription]];
        
        CardOptionItemModel *minionType = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeMinionType
                                                                            slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeMinionType]}
                                                                       sectionHeaderTexts:nil
                                                                            showsEmptyRow:YES
                                                                  allowsMultipleSelection:YES
                                                                               comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeMinionType][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeMinionType][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                    title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeMinionType]
                                                                             accessoryText:nil
                                                                                  toolTip:[ResourcesService localizationForKey:LocalizableKeyCardMinionTypeTooltipDescription]];
        
        CardOptionItemModel *spellSchoolType = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeSpellSchool
                                                                                 slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSpellSchool]}
                                                                            sectionHeaderTexts:nil
                                                                                 showsEmptyRow:YES
                                                                       allowsMultipleSelection:YES
                                                                                    comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSpellSchool][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSpellSchool][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                         title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeSpellSchool]
                                                                                  accessoryText:nil
                                                                                       toolTip:[ResourcesService localizationForKey:LocalizableKeyCardSpellSchoolTooltipDescription]];
        
        CardOptionItemModel *keywordItem = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeKeyword
                                                                             slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeKeyword]}
                                                                        sectionHeaderTexts:nil
                                                                             showsEmptyRow:YES
                                                                   allowsMultipleSelection:YES
                                                                                comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeKeyword][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeKeyword][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                     title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeKeyword]
                                                                              accessoryText:nil
                                                                                   toolTip:[ResourcesService localizationForKey:LocalizableKeyCardKeywordTooltipDescription]];
        
        CardOptionItemModel *textFilterItem = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeTextFilter
                                                                                slugsAndNames:nil
                                                                           sectionHeaderTexts:nil
                                                                                showsEmptyRow:YES
                                                                      allowsMultipleSelection:NO
                                                                                   comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            return NSOrderedSame;;
        }
                                                                                        title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeTextFilter]
                                                                                 accessoryText:nil
                                                                                      toolTip:[ResourcesService localizationForKey:LocalizableKeyCardTextFilterTooltipDescription]];
        
        CardOptionItemModel *gameModeItem = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeGameMode
                                                                              slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeGameMode]}
                                                                         sectionHeaderTexts:nil
                                                                              showsEmptyRow:NO
                                                                    allowsMultipleSelection:NO
                                                                                 comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeGameMode][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeGameMode][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                      title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeGameMode]
                                                                               accessoryText:nil
                                                                                    toolTip:[ResourcesService localizationForKey:LocalizableKeyCardGameModeTooltipDescription]];
        
        CardOptionItemModel *sortItem = [[CardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeSort
                                                                          slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: [ResourcesService localizationsForHSCardSort]}
                                                                     sectionHeaderTexts:nil
                                                                          showsEmptyRow:NO
                                                                allowsMultipleSelection:YES
                                                                             comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:HSCardSortFromNSString(lhs)];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:HSCardSortFromNSString(rhs)];
            return [lhsNumber compare:rhsNumber];
        }
                                                                                  title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeSort]
                                                                           accessoryText:nil
                                                                                toolTip:[ResourcesService localizationForKey:LocalizableKeyCardSortTooltipDescription]];
        
        //
        
        [snapshot appendSectionsWithIdentifiers:@[firstSectionModel, secondSectionModel, thirdSectionModel, forthSectionModel, fifthSectionModel]];
        
        [snapshot appendItemsWithIdentifiers:@[textFilterItem]
                   intoSectionWithIdentifier:firstSectionModel];
        
        [snapshot appendItemsWithIdentifiers:@[setItem, classItem]
                   intoSectionWithIdentifier:secondSectionModel];
        
        [snapshot appendItemsWithIdentifiers:@[manaCostItem, attackItem, healthItem]
                   intoSectionWithIdentifier:thirdSectionModel];
        
        [snapshot appendItemsWithIdentifiers:@[collectibleItem, rarityItem, typeItem, minionType, spellSchoolType, keywordItem, gameModeItem]
                   intoSectionWithIdentifier:forthSectionModel];
        
        [snapshot appendItemsWithIdentifiers:@[sortItem]
                   intoSectionWithIdentifier:fifthSectionModel];
        
        //
        
        [firstSectionModel release];
        [secondSectionModel release];
        [thirdSectionModel release];
        [forthSectionModel release];
        [fifthSectionModel release];
        
        [setItem release];
        [classItem release];
        [manaCostItem release];
        [attackItem release];
        [healthItem release];
        [collectibleItem release];
        [rarityItem release];
        [typeItem release];
        [minionType release];
        [spellSchoolType release];
        [keywordItem release];
        [textFilterItem release];
        [gameModeItem release];
        [sortItem release];
        
        //
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [self postEndedLoadingDataSource];
        }];
        [hsMetaData release];
        [snapshot release];
    }];
}

- (void)postStaredLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardOptionsViewModelStartedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postEndedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardOptionsViewModelEndedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postError:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardOptionsViewModelErrorOccured
                                                      object:self
                                                    userInfo:@{CardOptionsViewModelErrorOccuredErrorItemKey: error}];
}

@end
