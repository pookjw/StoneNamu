//
//  DeckAddCardOptionsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "DeckAddCardOptionsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "PickerSectionModel.h"
#import "PickerItemModel.h"

@interface DeckAddCardOptionsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@end

@implementation DeckAddCardOptionsViewModel

- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        self.localDeck = nil;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        LocalDeckUseCaseImpl *localDeckUseCase = [LocalDeckUseCaseImpl new];
        self.localDeckUseCase = localDeckUseCase;
        [localDeckUseCase release];
        
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
        
        [self configureSnapshot];
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_localDeck release];
    [_queue release];
    [_localDeckUseCase release];
    [_hsMetaDataUseCase release];
    [super dealloc];
}

- (NSDictionary<NSString *,NSSet<NSString *> *> *)options {
    NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
    NSArray<DeckAddCardOptionItemModel *> *itemModels = snapshot.itemIdentifiers;
    
    NSMutableDictionary<NSString *, NSSet<NSString *> *> *dic = [NSMutableDictionary<NSString *, NSSet<NSString *> *> new];
    
    [itemModels enumerateObjectsUsingBlock:^(DeckAddCardOptionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (void)updateDataSourceWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> * _Nullable)options {
    [self.queue addBarrierBlock:^{
        NSDictionary<NSString *, NSSet<NSString *> *> *nonnullOptions;
        
        if (options) {
            nonnullOptions = options;
        } else {
            nonnullOptions = @{};
        }
        
        //
        
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        NSMutableArray<DeckAddCardOptionItemModel *> *toBeReconfiguredItemModels = [NSMutableArray<DeckAddCardOptionItemModel *> new];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckAddCardOptionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        DeckAddCardOptionItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
        
        if ([itemModel.optionType isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
            NSMutableDictionary *userInfo = [NSMutableDictionary new];
            
            userInfo[DeckAddCardOptionsViewModelPresentTextFieldOptionTypeItemKey] = itemModel.optionType;
            
            if ([itemModel.values hasValuesWhenStringType]) {
                userInfo[DeckAddCardOptionsViewModelPresentTextFieldTextItemKey] = itemModel.values.allObjects.firstObject;
            }
            
            userInfo[DeckAddCardOptionsViewModelPresentTextFieldIndexPathItemKey] = indexPath;
            
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardOptionsViewModelPresentTextField
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
            
            userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationOptionTypeItemKey] = itemModel.optionType;
            userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationPickersItemKey] = pickers;
            userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationAllowsMultipleSelectionItemKey] = [NSNumber numberWithBool:itemModel.allowsMultipleSelection];
            userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationComparatorItemKey] = itemModel.comparator;
            
            [pickers release];
            
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardOptionsViewModelPresentPicker
                                                              object:self
                                                            userInfo:userInfo];
            
            [userInfo release];
        }
    }];
}

- (void)updateItem:(DeckAddCardOptionItemModel *)itemModel withValues:(NSSet<NSString *> * _Nullable)values {
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
        NSMutableArray<DeckAddCardOptionItemModel *> *toBeReconfiguredItemModels = [NSMutableArray<DeckAddCardOptionItemModel *> new];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckAddCardOptionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        
        [toBeReconfiguredItemModels enumerateObjectsUsingBlock:^(DeckAddCardOptionItemModel * _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            
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
        
        DeckAddCardOptionSectionModel *firstSectionModel = [[DeckAddCardOptionSectionModel alloc] initWithType:DeckAddCardOptionSectionModelTypeFirst];
        DeckAddCardOptionSectionModel *secondSectionModel = [[DeckAddCardOptionSectionModel alloc] initWithType:DeckAddCardOptionSectionModelTypeSecond];
        DeckAddCardOptionSectionModel *thirdSectionModel = [[DeckAddCardOptionSectionModel alloc] initWithType:DeckAddCardOptionSectionModelTypeThird];
        DeckAddCardOptionSectionModel *forthSectionModel = [[DeckAddCardOptionSectionModel alloc] initWithType:DeckAddCardOptionSectionModelTypeForth];
        DeckAddCardOptionSectionModel *fifthSectionModel = [[DeckAddCardOptionSectionModel alloc] initWithType:DeckAddCardOptionSectionModelTypeFifth];
        
        //
        
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *optionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:nil withClassId:self.localDeck.classId usingHSMetaData:hsMetaData];
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *optionTypesAndSlugsAndIds = [self.hsMetaDataUseCase optionTypesAndSlugsAndIdsFromHSDeckFormat:nil withClassId:self.localDeck.classId usingHSMetaData:hsMetaData];
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
        
        NSDictionary<NSNumber *, NSDictionary<NSString *, NSString *> *> * _Nullable setsSlugsAndNames;
        NSDictionary<NSNumber *, NSString *> * _Nullable setsSectionHeaderTexts;
        
        if ([HSDeckFormatClassic isEqualToString:self.localDeck.format]) {
            NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *classicOptionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:HSDeckFormatClassic withClassId:self.localDeck.classId usingHSMetaData:hsMetaData];
            NSDictionary<NSString *, NSString *> *classicSetSlugsAndNames = classicOptionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSet];
            
            setsSlugsAndNames = @{[NSNumber numberWithUnsignedInt:1 << 1]: classicSetSlugsAndNames};
            setsSectionHeaderTexts = @{[NSNumber numberWithUnsignedInt:1 << 1]: [ResourcesService localizationForHSDeckFormat:HSDeckFormatClassic]};
        } else if ([HSDeckFormatStandard isEqualToString:self.localDeck.format]) {
            NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *standardOptionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:HSDeckFormatStandard withClassId:self.localDeck.classId usingHSMetaData:hsMetaData];
            NSMutableDictionary<NSString *, NSString *> *standardSetSlugsAndNames = [standardOptionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSet] mutableCopy];
            
            standardSetSlugsAndNames[HSCardSetSlugTypeStandardCards] = [ResourcesService localizationForHSDeckFormat:HSDeckFormatStandard];
            
            setsSlugsAndNames = @{[NSNumber numberWithUnsignedInt:1 << 1]: standardSetSlugsAndNames};
            setsSectionHeaderTexts = @{[NSNumber numberWithUnsignedInt:1 << 1]: [ResourcesService localizationForHSDeckFormat:HSDeckFormatStandard]};
            
            [standardSetSlugsAndNames release];
        } else if ([HSDeckFormatWild isEqualToString:self.localDeck.format]) {
            NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *standardOptionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:HSDeckFormatStandard withClassId:self.localDeck.classId usingHSMetaData:hsMetaData];
            NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *wildOptionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:HSDeckFormatWild withClassId:self.localDeck.classId usingHSMetaData:hsMetaData];
            
            NSMutableDictionary<NSString *, NSString *> *standardSetSlugsAndNames = [standardOptionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSet] mutableCopy];
            NSMutableDictionary<NSString *, NSString *> *wildSetSlugsAndNames = [wildOptionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSet] mutableCopy];
            
            [standardSetSlugsAndNames.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [wildSetSlugsAndNames removeObjectForKey:obj];
            }];
            
            standardSetSlugsAndNames[HSCardSetSlugTypeStandardCards] = [ResourcesService localizationForHSDeckFormat:HSDeckFormatStandard];
            wildSetSlugsAndNames[HSCardSetSlugTypeWildCards] = [ResourcesService localizationForHSDeckFormat:HSDeckFormatWild];
            
            setsSlugsAndNames = @{[NSNumber numberWithUnsignedInt:1 << 1]: standardSetSlugsAndNames,
                                  [NSNumber numberWithUnsignedInt:1 << 2]: wildSetSlugsAndNames
            };
            setsSectionHeaderTexts = @{[NSNumber numberWithUnsignedInt:1 << 1]: [ResourcesService localizationForHSDeckFormat:HSDeckFormatStandard],
                                       [NSNumber numberWithUnsignedInt:1 << 2]: [ResourcesService localizationForHSDeckFormat:HSDeckFormatWild]
            };
            
            [standardSetSlugsAndNames release];
            [wildSetSlugsAndNames release];
        } else {
            setsSlugsAndNames = nil;
            setsSectionHeaderTexts = nil;
        }
        
        NSMutableDictionary<NSString *, NSNumber *> *setSlugsAndIds = [optionTypesAndSlugsAndIds[BlizzardHSAPIOptionTypeSet] mutableCopy];
        setSlugsAndIds[HSCardSetSlugTypeStandardCards] = [NSNumber numberWithUnsignedInteger:HSCardSetIdTypeStandardCards];
        setSlugsAndIds[HSCardSetSlugTypeWildCards] = [NSNumber numberWithUnsignedInteger:HSCardSetIdTypeWildCards];
        
        DeckAddCardOptionItemModel *setItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeSet
                                                                                       slugsAndNames:setsSlugsAndNames
                                                                                  sectionHeaderTexts:setsSectionHeaderTexts
                                                                                       showsEmptyRow:NO
                                                                             allowsMultipleSelection:NO
                                                                                          comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = setSlugsAndIds[lhs];
            NSNumber *rhsNumber = setSlugsAndIds[rhs];
            return [rhsNumber compare:lhsNumber];
        }
                                                                                               title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeSet]
                                                                                       accessoryText:nil
                                                                                             toolTip:[ResourcesService localizationForKey:LocalizableKeyCardSetTooltipDescription]];
        
        [setSlugsAndIds release];
        
        //
        
        DeckAddCardOptionItemModel *classItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeClass
                                                                                         slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeClass]}
                                                                                    sectionHeaderTexts:nil
                                                                                         showsEmptyRow:NO
                                                                               allowsMultipleSelection:YES
                                                                                            comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeClass][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeClass][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                                 title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeClass]
                                                                                         accessoryText:nil
                                                                                               toolTip:[ResourcesService localizationForKey:LocalizableKeyCardClassTooltipDescription]];
        
        DeckAddCardOptionItemModel *manaCostItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeManaCost
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
        
        DeckAddCardOptionItemModel *attackItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeAttack
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
        
        DeckAddCardOptionItemModel *healthItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeHealth
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
        
        DeckAddCardOptionItemModel *collectibleItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeCollectible
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
        
        DeckAddCardOptionItemModel *rarityItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeRarity
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
        
        DeckAddCardOptionItemModel *typeItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeType
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
        
        DeckAddCardOptionItemModel *minionType = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeMinionType
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
        
        DeckAddCardOptionItemModel *spellSchoolType = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeSpellSchool
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
        
        DeckAddCardOptionItemModel *keywordItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeKeyword
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
        
        DeckAddCardOptionItemModel *textFilterItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeTextFilter
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
        
        DeckAddCardOptionItemModel *gameModeItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeGameMode
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
        
        DeckAddCardOptionItemModel *sortItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeSort
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

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:NSNotificationNameLocalDeckUseCaseObserveData
                                             object:self.localDeckUseCase];
}

- (void)localDeckChangesReceived:(NSNotification *)notification {
    if (self.localDeck != nil) {
        [self.localDeckUseCase refreshObject:self.localDeck mergeChanges:NO completion:^{
            [self reconfigureDataSourceWhenLocalDeckChanged];
        }];
    }
}

- (void)reconfigureDataSourceWhenLocalDeckChanged {
    //    [self.queue addBarrierBlock:^{
    //        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
    //
    //        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckAddCardOptionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            obj.deckFormat = self.localDeck.format;
    //            obj.classId = self.localDeck.classId.unsignedIntegerValue;
    //        }];
    //
    //        [snapshot reconfigureItemsWithIdentifiers:snapshot.itemIdentifiers];
    //
    //        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
    //        [snapshot release];
    //    }];
}

- (void)postStaredLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardOptionsViewModelStartedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postEndedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardOptionsViewModelEndedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postError:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardOptionsViewModelErrorOccured
                                                      object:self
                                                    userInfo:@{DeckAddCardOptionsViewModelErrorOccuredErrorItemKey: error}];
}

@end
