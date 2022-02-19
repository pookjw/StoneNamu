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
                    
                    [newValues enumerateObjectsUsingBlock:^(NSString * _Nonnull value, BOOL * _Nonnull stop) {
                        NSString * _Nullable text = obj.slugsAndNames[value];
                        
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
            
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardOptionsViewModelPresentTextField
                                                              object:self
                                                            userInfo:userInfo];
            
            [userInfo release];
        } else {
            NSMutableDictionary *userInfo = [NSMutableDictionary new];
            
            userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationOptionTypeItemKey] = itemModel.optionType;
            userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationSlugsAndNamesKey] = itemModel.slugsAndNames;
            
            if ([itemModel.values hasValuesWhenStringType]) {
                userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationValuesItemKey] = itemModel.values.allObjects.firstObject;
            }
            
            userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationShowsEmptyRowItemKey] = [NSNumber numberWithBool:itemModel.showsEmptyRow];
            
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardOptionsViewModelPresentTextField
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
                
                [obj1.values enumerateObjectsUsingBlock:^(NSString * _Nonnull obj2, BOOL * _Nonnull stop) {
                    NSString * _Nullable text = obj1.slugsAndNames[obj2];
                    
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
        
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *optionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:nil withClassId:nil usingHSMetaData:hsMetaData];
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *optionTypesAndSlugsAndIds = [self.hsMetaDataUseCase optionTypesAndSlugsAndIdsFromHSDeckFormat:nil withClassId:nil usingHSMetaData:hsMetaData];
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
        
        DeckAddCardOptionItemModel *setItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeSet
                                                                                       slugsAndNames:optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSet]
                                                                                       showsEmptyRow:YES
                                                                                          comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = optionTypesAndSlugsAndIds[BlizzardHSAPIOptionTypeSet][lhs];
            NSNumber *rhsNumber = optionTypesAndSlugsAndIds[BlizzardHSAPIOptionTypeSet][rhs];
            return [rhsNumber compare:lhsNumber];
        }
                                                                                               title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeSet]
                                                                                       accessoryText:nil
                                                                                             toolTip:[ResourcesService localizationForKey:LocalizableKeyCardSetTooltipDescription]];
        
        DeckAddCardOptionItemModel *classItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeClass
                                                                                         slugsAndNames:optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeClass]
                                                                                         showsEmptyRow:YES
                                                                                            comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeClass][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeClass][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                                 title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeClass]
                                                                                         accessoryText:nil
                                                                                               toolTip:[ResourcesService localizationForKey:LocalizableKeyCardClassTooltipDescription]];
        
        DeckAddCardOptionItemModel *manaCostItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeManaCost
                                                                                            slugsAndNames:slugsAndNumberNames
                                                                                            showsEmptyRow:YES
                                                                                               comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:lhs.integerValue];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:rhs.integerValue];
            return [lhsNumber compare:rhsNumber];
        }
                                                                                                    title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeManaCost]
                                                                                            accessoryText:nil
                                                                                                  toolTip:[ResourcesService localizationForKey:LocalizableKeyCardManaCostTooltipDescription]];
        
        DeckAddCardOptionItemModel *attackItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeAttack
                                                                                          slugsAndNames:slugsAndNumberNames
                                                                                          showsEmptyRow:YES
                                                                                             comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:lhs.integerValue];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:rhs.integerValue];
            return [lhsNumber compare:rhsNumber];
        }
                                                                                                  title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeAttack]
                                                                                          accessoryText:nil
                                                                                                toolTip:[ResourcesService localizationForKey:LocalizableKeyCardAttackTooltipDescription]];
        
        DeckAddCardOptionItemModel *healthItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeHealth
                                                                                          slugsAndNames:slugsAndNumberNames
                                                                                          showsEmptyRow:YES
                                                                                             comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:lhs.integerValue];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:rhs.integerValue];
            return [lhsNumber compare:rhsNumber];
        }
                                                                                                  title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeHealth]
                                                                                          accessoryText:nil
                                                                                                toolTip:[ResourcesService localizationForKey:LocalizableKeyCardHealthTooltipDescription]];
        
        DeckAddCardOptionItemModel *collectibleItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeCollectible
                                                                                               slugsAndNames:[ResourcesService localizationsForHSCardCollectible]
                                                                                               showsEmptyRow:NO
                                                                                                  comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:HSCardCollectibleFromNSString(lhs)];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:HSCardCollectibleFromNSString(rhs)];
            return [lhsNumber compare:rhsNumber];
        }
                                                                                                       title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeCollectible]
                                                                                               accessoryText:nil
                                                                                                     toolTip:[ResourcesService localizationForKey:LocalizableKeyCardCollectibleTooltipDescription]];
        
        DeckAddCardOptionItemModel *rarityItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeRarity
                                                                                          slugsAndNames:optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeRarity]
                                                                                          showsEmptyRow:YES
                                                                                             comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = optionTypesAndSlugsAndIds[BlizzardHSAPIOptionTypeRarity][lhs];
            NSNumber *rhsNumber = optionTypesAndSlugsAndIds[BlizzardHSAPIOptionTypeRarity][rhs];
            return [lhsNumber compare:rhsNumber];
        }
                                                                                                  title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeRarity]
                                                                                          accessoryText:nil
                                                                                                toolTip:[ResourcesService localizationForKey:LocalizableKeyCardRarityTooltipDescription]];
        
        DeckAddCardOptionItemModel *typeItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeType
                                                                                        slugsAndNames:optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeType]
                                                                                        showsEmptyRow:YES
                                                                                           comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeType][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeType][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                                title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeType]
                                                                                        accessoryText:nil
                                                                                              toolTip:[ResourcesService localizationForKey:LocalizableKeyCardTypeTooltipDescription]];
        
        DeckAddCardOptionItemModel *minionType = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeMinionType
                                                                                          slugsAndNames:optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeMinionType]
                                                                                          showsEmptyRow:YES comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeMinionType][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeMinionType][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                                  title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeMinionType]
                                                                                          accessoryText:nil
                                                                                                toolTip:[ResourcesService localizationForKey:LocalizableKeyCardMinionTypeTooltipDescription]];
        
        DeckAddCardOptionItemModel *spellSchoolType = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeSpellSchool
                                                                                               slugsAndNames:optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSpellSchool]
                                                                                               showsEmptyRow:YES
                                                                                                  comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSpellSchool][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSpellSchool][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                                       title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeSpellSchool]
                                                                                               accessoryText:nil
                                                                                                     toolTip:[ResourcesService localizationForKey:LocalizableKeyCardSpellSchoolTooltipDescription]];
        
        DeckAddCardOptionItemModel *keywordItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeKeyword
                                                                                           slugsAndNames:optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeKeyword]
                                                                                           showsEmptyRow:YES
                                                                                              comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeKeyword][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeKeyword][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                                   title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeKeyword]
                                                                                           accessoryText:nil
                                                                                                 toolTip:[ResourcesService localizationForKey:LocalizableKeyCardKeywordTooltipDescription]];
        
        DeckAddCardOptionItemModel *textFilterItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeTextFilter
                                                                                              slugsAndNames:optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeTextFilter]
                                                                                              showsEmptyRow:YES
                                                                                                 comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            return NSOrderedSame;;
        }
                                                                                                      title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeTextFilter]
                                                                                              accessoryText:nil
                                                                                                    toolTip:[ResourcesService localizationForKey:LocalizableKeyCardTextFilterTooltipDescription]];
        
        DeckAddCardOptionItemModel *gameModeItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeGameMode
                                                                                            slugsAndNames:optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeGameMode]
                                                                                            showsEmptyRow:NO
                                                                                               comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSString *lhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeGameMode][lhs];
            NSString *rhsName = optionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeGameMode][rhs];
            return [lhsName compare:rhsName];
        }
                                                                                                    title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeGameMode]
                                                                                            accessoryText:nil
                                                                                                  toolTip:[ResourcesService localizationForKey:LocalizableKeyCardGameModeTooltipDescription]];
        
        DeckAddCardOptionItemModel *sortItem = [[DeckAddCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeSort
                                                                                        slugsAndNames:[ResourcesService localizationsForHSCardSort]
                                                                                        showsEmptyRow:NO
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
