//
//  DeckAddCardOptionsMenuFactory.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "DeckAddCardOptionsMenuFactory.h"
#import "StorableMenuItem.h"
#import "StorableSearchField.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckAddCardOptionsMenuFactory ()
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@property (retain) NSOperationQueue *queue;
@property (retain) LocalDeck * _Nullable localDeck;
@end

@implementation DeckAddCardOptionsMenuFactory

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck {
    self = [self init];
    
    if (self) {
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
        
        LocalDeckUseCaseImpl *localDeckUseCase = [LocalDeckUseCaseImpl new];
        self.localDeckUseCase = localDeckUseCase;
        [localDeckUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        [self->_slugsAndIds release];
        self->_slugsAndIds = nil;
        
        [self->_slugsAndNames release];
        self->_slugsAndNames = nil;
        
        self.localDeck = localDeck;
        
        [self bind];
    }
    
    return self;
}

- (void)dealloc {
    [_hsMetaDataUseCase release];
    [_localDeckUseCase release];
    [_queue release];
    [_slugsAndIds release];
    [_slugsAndNames release];
    [_classicSetSlugsAndNames release];
    [_standardSetSlugsAndNames release];
    [_wildSetSlugsAndNames release];
    [_localDeck release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self]) {
        if ([keyPath isEqualToString:@"localDeck"]) {
            if (self.localDeck) {
                [self updateItems];
            }
        } else {
            return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (SEL)keyMenuItemTriggeredSelector {
    return NSSelectorFromString(@"keyMenuItemTriggered:");
}

- (BOOL)hasEmptyItemAtOptionType:(BlizzardHSAPIOptionType)optionType {
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NO;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return NO;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NO;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NO;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NO;
    } else {
        return NO;
    }
}

- (BOOL)supportsMultipleSelectionFromOptionType:(BlizzardHSAPIOptionType)optionType {
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NO;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NO;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString * _Nullable)titleForOptionType:(BlizzardHSAPIOptionType)optionType {
    return [ResourcesService localizationForBlizzardHSAPIOptionType:optionType];
}

- (NSImage *)imageForCardOptionTypeWithValues:(NSSet<NSString *> *)values optionType:(BlizzardHSAPIOptionType)optionType {
    BOOL hasValue;
    
    if (values == nil) {
        hasValue = NO;
    } else {
        hasValue = values.hasValuesWhenStringType;
    }
    
    return [ResourcesService imageForBlizzardHSAPIOptionType:optionType fill:hasValue];
}

- (NSMenu *)menuForOptionType:(BlizzardHSAPIOptionType)optionType target:(nonnull id<NSSearchFieldDelegate>)target {
    NSMenu *menu = [NSMenu new];
    
    NSArray<NSMenuItem *> *itemArray;
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        itemArray = [self itemArrayForSetsUsingTarget:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        itemArray = [self itemArrayFromDic:self.slugsAndNames[optionType]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                comparator:^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSString *lhsName = self.slugsAndNames[optionType][lhs];
            NSString *rhsName = self.slugsAndNames[optionType][rhs];
            return [lhsName compare:rhsName];
        }
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost] || ([optionType isEqualToString:BlizzardHSAPIOptionTypeAttack] || ([optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]))) {
        itemArray = [self itemArrayFromDic:@{@"0": @"0",
                                             @"1": @"1",
                                             @"2": @"2",
                                             @"3": @"3",
                                             @"4": @"4",
                                             @"5": @"5",
                                             @"6": @"6",
                                             @"7": @"7",
                                             @"8": @"8",
                                             @"9": @"9",
                                             @"10": @"10+"}
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                comparator:^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:lhs.integerValue];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:rhs.integerValue];
            return [lhsNumber compare:rhsNumber];
        }
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardCollectible]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                comparator:^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:HSCardCollectibleFromNSString(lhs)];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:HSCardCollectibleFromNSString(rhs)];
            return [lhsNumber compare:rhsNumber];
        }
                                    target:target];
        
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        itemArray = [self itemArrayFromDic:self.slugsAndNames[optionType]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                comparator:^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSNumber *lhsNumber = self.slugsAndIds[optionType][lhs];
            NSNumber *rhsNumber = self.slugsAndIds[optionType][rhs];
            return [lhsNumber compare:rhsNumber];
        }
                                    target:target];
        
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        itemArray = [self itemArrayFromDic:self.slugsAndNames[optionType]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                comparator:^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSString *lhsName = self.slugsAndNames[optionType][lhs];
            NSString *rhsName = self.slugsAndNames[optionType][rhs];
            return [lhsName compare:rhsName];
        }
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        itemArray = [self itemArrayFromDic:self.slugsAndNames[optionType]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                comparator:^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSString *lhsName = self.slugsAndNames[optionType][lhs];
            NSString *rhsName = self.slugsAndNames[optionType][rhs];
            return [lhsName compare:rhsName];
        }
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        itemArray = [self itemArrayFromDic:self.slugsAndNames[optionType]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                comparator:^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSString *lhsName = self.slugsAndNames[optionType][lhs];
            NSString *rhsName = self.slugsAndNames[optionType][rhs];
            return [lhsName compare:rhsName];
        }
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        itemArray = [self itemArrayFromDic:self.slugsAndNames[optionType]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                comparator:^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSString *lhsName = self.slugsAndNames[optionType][lhs];
            NSString *rhsName = self.slugsAndNames[optionType][rhs];
            return [lhsName compare:rhsName];
        }
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        itemArray = @[[self searchFieldItemWithOptionType:optionType searchFieldDelegate:target]];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        itemArray = [self itemArrayFromDic:self.slugsAndNames[optionType]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                comparator:^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSString *lhsName = self.slugsAndNames[optionType][lhs];
            NSString *rhsName = self.slugsAndNames[optionType][rhs];
            return [lhsName compare:rhsName];
        }
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardSort]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                comparator:^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:HSCardSortFromNSString(lhs)];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:HSCardSortFromNSString(rhs)];
            return [lhsNumber compare:rhsNumber];
        }
                                    target:target];
    } else {
        itemArray = @[];
    }
    
    menu.itemArray = itemArray;
    menu.autoenablesItems = NO;
    
    return [menu autorelease];
}

- (NSArray<NSMenuItem *> *)itemArrayFromDic:(NSDictionary<NSString *, NSString *> *)dic
                                 optionType:(BlizzardHSAPIOptionType)type
                              showEmptyItem:(BOOL)showEmptyItem
                                filterArray:(NSArray<NSString *> * _Nullable)filterArray
                                imageSource:(NSImage * _Nullable (^)(NSString *))imageSource
                                 comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator
                                     target:(id)target {
    
    NSMutableArray<NSMenuItem *> *arr = [NSMutableArray<NSMenuItem *> new];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (![filterArray containsObject:key]) {
            StorableMenuItem *item = [[StorableMenuItem alloc] initWithTitle:obj
                                                                      action:self.keyMenuItemTriggeredSelector
                                                               keyEquivalent:@""
                                                                    userInfo:@{DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey: type,
                                                                               DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey: key,
                                                                               DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: [NSNumber numberWithBool:showEmptyItem],
                                                                               DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:type]]}];
            item.target = target;
            
            [arr addObject:item];
            [item release];
        }
    }];
    
    [arr sortUsingComparator:^NSComparisonResult(NSMenuItem * _Nonnull lhsItem, NSMenuItem * _Nonnull rhsItem) {
        NSString *lhsValue = ((StorableMenuItem *)lhsItem).userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey];
        NSString *rhsValue = ((StorableMenuItem *)rhsItem).userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey];
        
        return comparator(lhsValue, rhsValue);
    }];
    
    if (showEmptyItem) {
        StorableMenuItem *emptyItem = [[StorableMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyAll]
                                                                       action:self.keyMenuItemTriggeredSelector
                                                                keyEquivalent:@""
                                                                     userInfo:@{DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey: type,
                                                                                DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey: @"",
                                                                                DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: [NSNumber numberWithBool:showEmptyItem],
                                                                                DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:type]]}];
        emptyItem.target = target;
        
        [arr insertObject:emptyItem atIndex:0];
        [emptyItem release];
        
        NSMenuItem *separatorItem = [NSMenuItem separatorItem];
        [arr insertObject:separatorItem atIndex:1];
    }
    
    return [arr autorelease];
}

- (NSArray<NSMenuItem *> *)itemArrayForSetsUsingTarget:(nonnull id<NSSearchFieldDelegate>)target {
    NSMutableDictionary<NSString *, NSNumber *> *setSlugsAndIds = [self.slugsAndIds[BlizzardHSAPIOptionTypeSet] mutableCopy];
    setSlugsAndIds[HSCardSetSlugTypeStandardCards] = [NSNumber numberWithUnsignedInteger:HSCardSetIdTypeStandardCards];
    setSlugsAndIds[HSCardSetSlugTypeWildCards] = [NSNumber numberWithUnsignedInteger:HSCardSetIdTypeWildCards];
    
    //
    
    NSMutableArray<NSMenuItem *> *arr = [NSMutableArray<NSMenuItem *> new];
    
    //
    
    void (^addClassicMenuItems)(void) = ^{
        NSMutableArray<NSMenuItem *> *classicMenuItems = [NSMutableArray<NSMenuItem *> new];
        
        [self.classicSetSlugsAndNames enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            StorableMenuItem *item = [[StorableMenuItem alloc] initWithTitle:obj
                                                                      action:self.keyMenuItemTriggeredSelector
                                                               keyEquivalent:@""
                                                                    userInfo:@{DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey: BlizzardHSAPIOptionTypeSet,
                                                                               DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey: key,
                                                                               DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: [NSNumber numberWithBool:YES],
                                                                               DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:BlizzardHSAPIOptionTypeSet]]}];
            item.target = target;
            [classicMenuItems addObject:item];
            [item release];
        }];
        
        [classicMenuItems sortUsingComparator:^NSComparisonResult(NSMenuItem * _Nonnull lhsItem, NSMenuItem * _Nonnull rhsItem) {
            NSString *lhsValue = ((StorableMenuItem *)lhsItem).userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey];
            NSString *rhsValue = ((StorableMenuItem *)rhsItem).userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey];
            
            NSNumber *lhsNumber = setSlugsAndIds[lhsValue];
            NSNumber *rhsNumber = setSlugsAndIds[rhsValue];
            
            return [rhsNumber compare:lhsNumber];
        }];
        
        NSMenuItem *classicTitleItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForHSDeckFormat:HSDeckFormatClassic]
                                                                  action:nil
                                                           keyEquivalent:@""];
        classicTitleItem.enabled = NO;
        [arr addObject:classicTitleItem];
        [classicTitleItem release];
        
        [arr addObjectsFromArray:classicMenuItems];
        [classicMenuItems release];
    };
    
    void (^addStandardMenuItems)(void) = ^{
        NSMutableArray<NSMenuItem *> *standardMenuItems = [NSMutableArray<NSMenuItem *> new];
        
        [self.standardSetSlugsAndNames enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            StorableMenuItem *item = [[StorableMenuItem alloc] initWithTitle:obj
                                                                      action:self.keyMenuItemTriggeredSelector
                                                               keyEquivalent:@""
                                                                    userInfo:@{DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey: BlizzardHSAPIOptionTypeSet,
                                                                               DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey: key,
                                                                               DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: [NSNumber numberWithBool:YES],
                                                                               DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:BlizzardHSAPIOptionTypeSet]]}];
            item.target = target;
            [standardMenuItems addObject:item];
            [item release];
        }];
        
        StorableMenuItem *standardItem = [[StorableMenuItem alloc] initWithTitle:[ResourcesService localizationForHSDeckFormat:HSDeckFormatStandard]
                                                                          action:self.keyMenuItemTriggeredSelector
                                                                   keyEquivalent:@""
                                                                        userInfo:@{DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey: BlizzardHSAPIOptionTypeSet,
                                                                                   DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey: HSCardSetSlugTypeStandardCards,
                                                                                   DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: [NSNumber numberWithBool:YES],
                                                                                   DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:BlizzardHSAPIOptionTypeSet]]}];
        standardItem.target = target;
        [standardMenuItems addObject:standardItem];
        [standardItem release];
        
        [standardMenuItems sortUsingComparator:^NSComparisonResult(NSMenuItem * _Nonnull lhsItem, NSMenuItem * _Nonnull rhsItem) {
            NSString *lhsValue = ((StorableMenuItem *)lhsItem).userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey];
            NSString *rhsValue = ((StorableMenuItem *)rhsItem).userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey];
            
            NSNumber *lhsNumber = setSlugsAndIds[lhsValue];
            NSNumber *rhsNumber = setSlugsAndIds[rhsValue];
            
            return [rhsNumber compare:lhsNumber];
        }];
        
        NSMenuItem *standardTitleItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForHSDeckFormat:HSDeckFormatStandard]
                                                                   action:nil
                                                            keyEquivalent:@""];
        standardTitleItem.enabled = NO;
        [arr addObject:standardTitleItem];
        [standardTitleItem release];
        
        [arr addObjectsFromArray:standardMenuItems];
        [standardMenuItems release];
    };
    
    void (^addWildMenuItems)(void) = ^{
        NSMutableArray<NSMenuItem *> *wildMenuItems = [NSMutableArray<NSMenuItem *> new];
        NSMutableDictionary<NSString *, NSString *> *wildSetSlugsAndNames = [self.wildSetSlugsAndNames mutableCopy];
        
        [self.standardSetSlugsAndNames.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [wildSetSlugsAndNames removeObjectForKey:obj];
        }];
        
        [wildSetSlugsAndNames enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            StorableMenuItem *item = [[StorableMenuItem alloc] initWithTitle:obj
                                                                      action:self.keyMenuItemTriggeredSelector
                                                               keyEquivalent:@""
                                                                    userInfo:@{DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey: BlizzardHSAPIOptionTypeSet,
                                                                               DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey: key,
                                                                               DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: [NSNumber numberWithBool:YES],
                                                                               DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:BlizzardHSAPIOptionTypeSet]]}];
            item.target = target;
            [wildMenuItems addObject:item];
            [item release];
        }];
        
        [wildSetSlugsAndNames release];
        
        StorableMenuItem *wildItem = [[StorableMenuItem alloc] initWithTitle:[ResourcesService localizationForHSDeckFormat:HSDeckFormatWild]
                                                                          action:self.keyMenuItemTriggeredSelector
                                                                   keyEquivalent:@""
                                                                        userInfo:@{DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey: BlizzardHSAPIOptionTypeSet,
                                                                                   DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey: HSDeckFormatWild,
                                                                                   DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: [NSNumber numberWithBool:YES],
                                                                                   DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:BlizzardHSAPIOptionTypeSet]]}];
        wildItem.target = target;
        [wildMenuItems addObject:wildItem];
        [wildItem release];
        
        [wildMenuItems sortUsingComparator:^NSComparisonResult(NSMenuItem * _Nonnull lhsItem, NSMenuItem * _Nonnull rhsItem) {
            NSString *lhsValue = ((StorableMenuItem *)lhsItem).userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey];
            NSString *rhsValue = ((StorableMenuItem *)rhsItem).userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey];
            
            NSNumber *lhsNumber = setSlugsAndIds[lhsValue];
            NSNumber *rhsNumber = setSlugsAndIds[rhsValue];
            
            return [rhsNumber compare:lhsNumber];
        }];
        
        NSMenuItem *wildTitleItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForHSDeckFormat:HSDeckFormatWild]
                                                               action:nil
                                                        keyEquivalent:@""];
        wildTitleItem.enabled = NO;
        [arr addObject:wildTitleItem];
        [wildTitleItem release];
        
        [arr addObjectsFromArray:wildMenuItems];
        [wildMenuItems release];
    };
    
    //
    
    if ([HSDeckFormatClassic isEqualToString:self.localDeck.format]) {
        addClassicMenuItems();
    } else if ([HSDeckFormatStandard isEqualToString:self.localDeck.format]) {
        addStandardMenuItems();
    } else if ([HSDeckFormatWild isEqualToString:self.localDeck.format]) {
        addStandardMenuItems();
        [arr addObject:[NSMenuItem separatorItem]];
        addWildMenuItems();
    }
    
    //
    
    [setSlugsAndIds release];
    return [arr autorelease];
}


- (NSMenuItem *)searchFieldItemWithOptionType:(BlizzardHSAPIOptionType)optionType
                          searchFieldDelegate:(nonnull id<NSSearchFieldDelegate>)searchFieldDelegate {
    StorableMenuItem *item = [[StorableMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@"" userInfo:@{DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey: optionType,
    DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey: @"",
    DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: @NO,
        DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:optionType]]}];
    StorableSearchField *searchField = [[StorableSearchField alloc] initWithUserInfo:@{optionType: @""}];
    
    searchField.frame = CGRectMake(0, 0, 300, 20);
    searchField.delegate = searchFieldDelegate;
    
    item.view = searchField;
    
    [searchField release];
    return [item autorelease];
}

- (void)updateItems {
    if (self.localDeck == nil) return;
    
    [self.queue addBarrierBlock:^{
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:0];
        HSMetaData * _Nullable __block hsMetaData = nil;
        
        [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable _hsMetaData, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
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
            return;
        }
        
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *slugsAndIds = [self.hsMetaDataUseCase optionTypesAndSlugsAndIdsFromHSDeckFormat:self.localDeck.format withClassId:self.localDeck.classId usingHSMetaData:hsMetaData];
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *slugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:self.localDeck.format withClassId:self.localDeck.classId usingHSMetaData:hsMetaData];
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *classicOptionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:HSDeckFormatClassic withClassId:self.localDeck.classId usingHSMetaData:hsMetaData];
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *standardOptionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:HSDeckFormatStandard withClassId:self.localDeck.classId usingHSMetaData:hsMetaData];
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *wildOptionTypesAndSlugsAndNames = [self.hsMetaDataUseCase optionTypesAndSlugsAndNamesFromHSDeckFormat:HSDeckFormatWild withClassId:self.localDeck.classId usingHSMetaData:hsMetaData];
        
        [hsMetaData release];
        
        [self->_slugsAndIds release];
        self->_slugsAndIds = [slugsAndIds copy];
        
        [self->_slugsAndNames release];
        self->_slugsAndNames = [slugsAndNames copy];
        
        [self->_classicSetSlugsAndNames release];
        self->_classicSetSlugsAndNames = [classicOptionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSet] copy];
        
        [self->_standardSetSlugsAndNames release];
        self->_standardSetSlugsAndNames = [standardOptionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSet] copy];
        
        [self->_wildSetSlugsAndNames release];
        self->_wildSetSlugsAndNames = [wildOptionTypesAndSlugsAndNames[BlizzardHSAPIOptionTypeSet] copy];
        
        [self postShouldUpdateItems];
    }];
}

- (void)bind {
    [self addObserver:self forKeyPath:@"localDeck" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:NSNotificationNameLocalDeckUseCaseObserveData
                                             object:self.localDeckUseCase];
}

- (void)localDeckChangesReceived:(NSNotification *)notification {
    if (self.localDeck != nil) {
        [self.localDeckUseCase refreshObject:self.localDeck mergeChanges:NO completion:^{
            
        }];
    }
}

- (void)postShouldUpdateItems {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardOptionsMenuFactoryShouldUpdateItems
                                                      object:self
                                                    userInfo:nil];
}

@end
