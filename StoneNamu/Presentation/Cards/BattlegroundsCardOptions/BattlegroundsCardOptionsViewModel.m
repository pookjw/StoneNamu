//
//  BattlegroundsCardOptionsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/26/22.
//

#import "BattlegroundsCardOptionsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "NSDiffableDataSourceSnapshot+sort.h"
#import "PickerSectionModel.h"
#import "PickerItemModel.h"

@interface BattlegroundsCardOptionsViewModel ()
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@property (retain) NSOperationQueue *queue;
@end

@implementation BattlegroundsCardOptionsViewModel

- (instancetype)initWithDataSource:(BattlegroundsCardOptionsDataSource *)dataSource {
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
    NSArray<BattlegroundsCardOptionItemModel *> *itemModels = snapshot.itemIdentifiers;
    
    NSMutableDictionary<NSString *, NSSet<NSString *> *> *dic = [NSMutableDictionary<NSString *, NSSet<NSString *> *> new];
    
    [itemModels enumerateObjectsUsingBlock:^(BattlegroundsCardOptionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        
        NSSet<NSString *> * _Nullable typeValues = nonnullOptions[BlizzardHSAPIOptionTypeType];
        if ((typeValues) && ([typeValues containsObject:HSCardTypeSlugTypeMinion])) {
            [self appendMinionFiltersSectionIfNeededToSnapShot:snapshot];
        } else {
            [self deleteMinionFiltersSectionIfNeededFromSnapShot:snapshot];
        }
        
        //
        
        NSMutableArray<BattlegroundsCardOptionItemModel *> *toBeReconfiguredItemModels = [NSMutableArray<BattlegroundsCardOptionItemModel *> new];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(BattlegroundsCardOptionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        BattlegroundsCardOptionItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
        
        if ([itemModel.optionType isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
            NSMutableDictionary *userInfo = [NSMutableDictionary new];
            
            userInfo[BattlegroundsCardOptionsViewModelPresentTextFieldOptionTypeItemKey] = itemModel.optionType;
            
            if ([itemModel.values hasValuesWhenStringType]) {
                userInfo[BattlegroundsCardOptionsViewModelPresentTextFieldTextItemKey] = itemModel.values.allObjects.firstObject;
            }
            
            userInfo[BattlegroundsCardOptionsViewModelPresentTextFieldIndexPathItemKey] = indexPath;
            
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameBattlegroundsCardOptionsViewModelPresentTextField
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
            
            userInfo[BattlegroundsCardOptionsViewModelPresentPickerNotificationTitleItemKey] = itemModel.title;
            userInfo[BattlegroundsCardOptionsViewModelPresentPickerNotificationOptionTypeItemKey] = itemModel.optionType;
            userInfo[BattlegroundsCardOptionsViewModelPresentPickerNotificationPickersItemKey] = pickers;
            userInfo[BattlegroundsCardOptionsViewModelPresentPickerNotificationAllowsMultipleSelectionItemKey] = [NSNumber numberWithBool:itemModel.allowsMultipleSelection];
            userInfo[BattlegroundsCardOptionsViewModelPresentPickerNotificationComparatorItemKey] = itemModel.comparator;
            
            [pickers release];
            
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameBattlegroundsCardOptionsViewModelPresentPicker
                                                              object:self
                                                            userInfo:userInfo];
            
            [userInfo release];
        }
    }];
}

- (void)updateOptionType:(BlizzardHSAPIOptionType)optionType withValues:(NSSet<NSString *> *)values {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        //
        
        
        
        if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
            if ((values) && ([values containsObject:HSCardTypeSlugTypeMinion])) {
                [self appendMinionFiltersSectionIfNeededToSnapShot:snapshot];
            } else {
                [self deleteMinionFiltersSectionIfNeededFromSnapShot:snapshot];
            }
        }
        
        //
        
        NSMutableArray<BattlegroundsCardOptionItemModel *> *toBeReconfiguredItemModels = [NSMutableArray<BattlegroundsCardOptionItemModel *> new];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(BattlegroundsCardOptionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        
        [toBeReconfiguredItemModels enumerateObjectsUsingBlock:^(BattlegroundsCardOptionItemModel * _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            
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
        
        BattlegroundsCardOptionSectionModel *firstSectionModel = [[BattlegroundsCardOptionSectionModel alloc] initWithType:BattlegroundsCardOptionSectionModelTypeFirst];
        BattlegroundsCardOptionSectionModel *secondSectionModel = [[BattlegroundsCardOptionSectionModel alloc] initWithType:BattlegroundsCardOptionSectionModelTypeSecond];
        BattlegroundsCardOptionSectionModel *fifthSectionModel = [[BattlegroundsCardOptionSectionModel alloc] initWithType:BattlegroundsCardOptionSectionModelTypeFifth];
        
        //
        
        HSCardType *heroHSCardType = [self.hsMetaDataUseCase hsCardTypeFromTypeSlug:HSCardTypeSlugTypeHero usingHSMetaData:hsMetaData];
        HSCardType *minionHSCardType = [self.hsMetaDataUseCase hsCardTypeFromTypeSlug:HSCardTypeSlugTypeMinion usingHSMetaData:hsMetaData];
        
        NSDictionary<NSString *, NSString *> *typeSlugsAndNames = @{heroHSCardType.slug: heroHSCardType.name,
                                                                    minionHSCardType.slug: minionHSCardType.name};
        NSDictionary<NSString *, NSNumber *> *typeSlugsAndIds = @{heroHSCardType.slug: heroHSCardType.typeId,
                                                                  minionHSCardType.slug: minionHSCardType.typeId};
        
        BattlegroundsCardOptionItemModel *typeItemModel = [[BattlegroundsCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeType
                                                                                                         slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: typeSlugsAndNames}
                                                                                                    sectionHeaderTexts:nil
                                                                                                         showsEmptyRow:NO
                                                                                               allowsMultipleSelection:NO
                                                                                                            comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            NSNumber *lhsNumber = typeSlugsAndIds[lhs];
            NSNumber *rhsNumber = typeSlugsAndIds[rhs];
            return [lhsNumber compare:rhsNumber];
        }
                                                                                                                 title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeType]
                                                                                                         accessoryText:nil
                                                                                                               toolTip:[ResourcesService localizationForKey:LocalizableKeyCardTypeTooltipDescription]];
        
        //
        
        BattlegroundsCardOptionItemModel *textFilterItemModel = [[BattlegroundsCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeTextFilter
                                                                                                               slugsAndNames:nil
                                                                                                          sectionHeaderTexts:nil
                                                                                                               showsEmptyRow:NO
                                                                                                     allowsMultipleSelection:NO
                                                                                                                  comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
            return NSOrderedSame;
        }
                                                                                                                       title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeTextFilter]
                                                                                                               accessoryText:nil
                                                                                                                     toolTip:[ResourcesService localizationForKey:LocalizableKeyCardTextFilterTooltipDescription]];
        
        //
        
        BattlegroundsCardOptionItemModel *sortItemModel = [[BattlegroundsCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeSort
                                                                                                         slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: [ResourcesService localizationsForHSCardSortWithHSCardGameModeSlugType:HSCardGameModeSlugTypeBattlegrounds]}
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
        
        [snapshot appendSectionsWithIdentifiers:@[firstSectionModel, secondSectionModel, fifthSectionModel]];
        
        [snapshot appendItemsWithIdentifiers:@[typeItemModel] intoSectionWithIdentifier:firstSectionModel];
        [snapshot appendItemsWithIdentifiers:@[textFilterItemModel] intoSectionWithIdentifier:secondSectionModel];
        [snapshot appendItemsWithIdentifiers:@[sortItemModel] intoSectionWithIdentifier:fifthSectionModel];
        
        //
        
        [typeItemModel release];
        [textFilterItemModel release];
        [sortItemModel release];
        
        //
        
        [firstSectionModel release];
        [secondSectionModel release];
        [fifthSectionModel release];
        
        //
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [self postEndedLoadingDataSource];
        }];
        [hsMetaData release];
        [snapshot release];
    }];
}

- (void)appendMinionFiltersSectionIfNeededToSnapShot:(NSDiffableDataSourceSnapshot *)snapshot {
    BOOL __block hasThirdSectionModel = NO;
    
    [self.dataSource.snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(BattlegroundsCardOptionSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (obj.type) {
            case BattlegroundsCardOptionSectionModelTypeThird:
                hasThirdSectionModel = YES;
                *stop = YES;
                break;
            default:
                break;
        }
    }];
    
    if (hasThirdSectionModel) return;
    
    //
    
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
    
    BattlegroundsCardOptionSectionModel *thirdSectionModel = [[BattlegroundsCardOptionSectionModel alloc] initWithType:BattlegroundsCardOptionSectionModelTypeThird];
    BattlegroundsCardOptionSectionModel *forthSectionModel = [[BattlegroundsCardOptionSectionModel alloc] initWithType:BattlegroundsCardOptionSectionModelTypeForth];
    
    NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *slugsAndNames = [self.hsMetaDataUseCase battlegroundsOptionTypesAndSlugsAndNamesUsingHSMetaData:hsMetaData];
//    NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *slugsAndIds = [self.hsMetaDataUseCase battlegroundsOptionTypesAndSlugsAndIdsUsingHSMetaData:hsMetaData];
    
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
    NSDictionary<NSString *, NSString *> *slugsAndTierNames = @{@"1": @"1",
                                                                @"2": @"2",
                                                                @"3": @"3",
                                                                @"4": @"4",
                                                                @"5": @"5",
                                                                @"6": @"6"};
    
    //
    
    BattlegroundsCardOptionItemModel *minionItemModel = [[BattlegroundsCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeMinionType
                                                                                                       slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: slugsAndNames[BlizzardHSAPIOptionTypeMinionType]}
                                                                                                  sectionHeaderTexts:nil
                                                                                                       showsEmptyRow:YES
                                                                                             allowsMultipleSelection:YES
                                                                                                          comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
        NSString *lhsName = slugsAndNames[BlizzardHSAPIOptionTypeMinionType][lhs];
        NSString *rhsName = slugsAndNames[BlizzardHSAPIOptionTypeMinionType][rhs];
        return [lhsName compare:rhsName];
    }
                                                                                                               title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeMinionType]
                                                                                                       accessoryText:nil
                                                                                                             toolTip:[ResourcesService localizationForKey:LocalizableKeyCardMinionTypeTooltipDescription]];
    
    //
    
    BattlegroundsCardOptionItemModel *keywordItemModel = [[BattlegroundsCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeKeyword
                                                                                                        slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: slugsAndNames[BlizzardHSAPIOptionTypeKeyword]}
                                                                                                   sectionHeaderTexts:nil
                                                                                                        showsEmptyRow:YES
                                                                                              allowsMultipleSelection:YES
                                                                                                           comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
        NSString *lhsName = slugsAndNames[BlizzardHSAPIOptionTypeKeyword][lhs];
        NSString *rhsName = slugsAndNames[BlizzardHSAPIOptionTypeKeyword][rhs];
        return [lhsName compare:rhsName];
    }
                                                                                                                title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeKeyword]
                                                                                                        accessoryText:nil
                                                                                                              toolTip:[ResourcesService localizationForKey:LocalizableKeyCardKeywordTooltipDescription]];
    
    //
    
    BattlegroundsCardOptionItemModel *tierItemModel = [[BattlegroundsCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeTier
                                                                                                     slugsAndNames:@{[NSNumber numberWithUnsignedInt:1 << 1]: slugsAndTierNames}
                                                                                                sectionHeaderTexts:nil
                                                                                                     showsEmptyRow:YES
                                                                                           allowsMultipleSelection:YES
                                                                                                        comparator:^NSComparisonResult(NSString * _Nonnull lhs, NSString * _Nonnull rhs) {
        NSNumber *lhsNumber = [NSNumber numberWithInteger:lhs.integerValue];
        NSNumber *rhsNumber = [NSNumber numberWithInteger:rhs.integerValue];
        return [lhsNumber compare:rhsNumber];
    }
                                                                                                             title:[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeTier]
                                                                                                     accessoryText:nil
                                                                                                           toolTip:[ResourcesService localizationForKey:LocalizableKeyCardTierTooltipDescription]];
    
    //
    
    BattlegroundsCardOptionItemModel *attackItemModel = [[BattlegroundsCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeAttack
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
    
    //
    
    BattlegroundsCardOptionItemModel *healthItemModel = [[BattlegroundsCardOptionItemModel alloc] initWithOptionType:BlizzardHSAPIOptionTypeHealth
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
    
    //
    
    [snapshot appendSectionsWithIdentifiers:@[thirdSectionModel, forthSectionModel]];
    
    [snapshot appendItemsWithIdentifiers:@[minionItemModel, keywordItemModel] intoSectionWithIdentifier:thirdSectionModel];
    [snapshot appendItemsWithIdentifiers:@[tierItemModel, attackItemModel, healthItemModel] intoSectionWithIdentifier:forthSectionModel];
    
    //
    
    [thirdSectionModel release];
    [forthSectionModel release];
    
    [minionItemModel release];
    [keywordItemModel release];
    [tierItemModel release];
    [attackItemModel release];
    [healthItemModel release];
    
    //
    
    [snapshot sortSectionsUsingComparator:^NSComparisonResult(BattlegroundsCardOptionSectionModel * _Nonnull obj1, BattlegroundsCardOptionSectionModel * _Nonnull obj2) {
        NSNumber *lhsNumber = [NSNumber numberWithUnsignedInteger:obj1.type];
        NSNumber *rhsNumber = [NSNumber numberWithUnsignedInteger:obj2.type];
        return [lhsNumber compare:rhsNumber];
    }];
}

- (void)deleteMinionFiltersSectionIfNeededFromSnapShot:(NSDiffableDataSourceSnapshot *)snapshot {
    BattlegroundsCardOptionSectionModel * __block thirdSectionModel = nil;
    BattlegroundsCardOptionSectionModel * __block forthSectionModel = nil;
    
    [snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(BattlegroundsCardOptionSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (obj.type) {
            case BattlegroundsCardOptionSectionModelTypeThird:
                thirdSectionModel = obj;
                break;
            case BattlegroundsCardOptionSectionModelTypeForth:
                forthSectionModel = obj;
                break;
            default:
                break;
        }
        
        if (thirdSectionModel && forthSectionModel) {
            *stop = YES;
        }
    }];
    
    //
    
    if (thirdSectionModel) {
        [snapshot deleteSectionsWithIdentifiers:@[thirdSectionModel]];
    }
    
    if (forthSectionModel) {
        [snapshot deleteSectionsWithIdentifiers:@[forthSectionModel]];
    }
}

- (void)postStaredLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameBattlegroundsCardOptionsViewModelStartedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postEndedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameBattlegroundsCardOptionsViewModelEndedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postError:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameBattlegroundsCardOptionsViewModelErrorOccured
                                                      object:self
                                                    userInfo:@{BattlegroundsCardOptionsViewModelErrorOccuredErrorItemKey: error}];
}

@end
