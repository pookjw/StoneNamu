//
//  BattlegroundsCardOptionsMenuFactory.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import "BattlegroundsCardOptionsMenuFactory.h"
#import "StorableMenuItem.h"
#import "StorableSearchField.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

@interface BattlegroundsCardOptionsMenuFactory ()
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@property (retain) NSOperationQueue *queue;
@end

@implementation BattlegroundsCardOptionsMenuFactory

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self->_slugsAndIds release];
        self->_slugsAndIds = nil;
        
        [self->_slugsAndNames release];
        self->_slugsAndNames = nil;
        
        [self->_typeSlugsAndIds release];
        self->_typeSlugsAndIds = nil;
        
        [self->_typeSlugsAndNames release];
        self->_typeSlugsAndNames = nil;
        
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        [self bind];
    }
    
    return self;
}

- (void)dealloc {
    [_slugsAndIds release];
    [_slugsAndNames release];
    [_typeSlugsAndIds release];
    [_typeSlugsAndNames release];
    [_hsMetaDataUseCase release];
    [_queue release];
    [super dealloc];
}

- (SEL)keyMenuItemTriggeredSelector {
    return NSSelectorFromString(@"keyMenuItemTriggered:");
}

- (BOOL)hasEmptyItemAtOptionType:(BlizzardHSAPIOptionType)optionType {
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTier]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NO;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NO;
    } else {
        return NO;
    }
}

- (BOOL)supportsMultipleSelectionFromOptionType:(BlizzardHSAPIOptionType)optionType {
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)isEnabledItemWithOptionType:(BlizzardHSAPIOptionType)optionType options:(NSDictionary<NSString *, NSSet<NSString *> *> *)options {
    NSSet<NSString *> * _Nullable typeValues = options[BlizzardHSAPIOptionTypeType];
    BOOL isMinionType;
    
    if ((typeValues) && ([typeValues containsObject:HSCardTypeSlugTypeMinion])) {
        isMinionType = YES;
    } else {
        isMinionType = NO;
    }
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTier]) {
        return isMinionType;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return isMinionType;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return isMinionType;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return isMinionType;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return isMinionType;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSDictionary<NSString *, NSSet<NSString *> *> *)validatedOptionsFromOptions:(NSDictionary<NSString *, NSSet<NSString *> *> *)options {
    NSSet<NSString *> * _Nullable typeValues = options[BlizzardHSAPIOptionTypeType];
    BOOL isMinionType;
    
    if ((typeValues) && ([typeValues containsObject:HSCardTypeSlugTypeMinion])) {
        isMinionType = YES;
    } else {
        isMinionType = NO;
    }
    
    //
    
    if (isMinionType) {
        return [[options copy] autorelease];
    } else {
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        
        [mutableOptions removeObjectsForKeys:@[BlizzardHSAPIOptionTypeTier, BlizzardHSAPIOptionTypeAttack, BlizzardHSAPIOptionTypeHealth, BlizzardHSAPIOptionTypeMinionType]];
        
        return [mutableOptions autorelease];
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

- (NSMenu *)menuForOptionType:(BlizzardHSAPIOptionType)optionType target:(id<NSSearchFieldDelegate>)target {
    NSMenu *menu = [NSMenu new];
    
    NSArray<NSMenuItem *> *itemArray;
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTier]) {
        itemArray = [self itemArrayFromDic:@{@"1": @"1",
                                             @"2": @"2",
                                             @"3": @"3",
                                             @"4": @"4",
                                             @"5": @"5",
                                             @"6": @"6"}
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
    } else if (([optionType isEqualToString:BlizzardHSAPIOptionTypeAttack] || ([optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]))) {
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
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        itemArray = [self itemArrayFromDic:self.typeSlugsAndNames
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                comparator:^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSString *lhsName = self.typeSlugsAndNames[lhs];
            NSString *rhsName = self.typeSlugsAndNames[rhs];
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
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardSortWithHSCardGameModeSlugType:HSCardGameModeSlugTypeBattlegrounds]
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
                                                                    userInfo:@{BattlegroundsCardOptionsMenuFactoryStorableMenuItemOptionTypeKey: type,
                                                                               BattlegroundsCardOptionsMenuFactoryStorableMenuItemValueKey: key,
                                                                               BattlegroundsCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: [NSNumber numberWithBool:showEmptyItem],
                                                                               BattlegroundsCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:type]]}];
            item.target = target;
            
            [arr addObject:item];
            [item release];
        }
    }];
    
    [arr sortUsingComparator:^NSComparisonResult(NSMenuItem * _Nonnull lhsItem, NSMenuItem * _Nonnull rhsItem) {
        NSString *lhsValue = ((StorableMenuItem *)lhsItem).userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemValueKey];
        NSString *rhsValue = ((StorableMenuItem *)rhsItem).userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemValueKey];
        
        return comparator(lhsValue, rhsValue);
    }];
    
    if (showEmptyItem) {
        StorableMenuItem *emptyItem = [[StorableMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyAll]
                                                                       action:self.keyMenuItemTriggeredSelector
                                                                keyEquivalent:@""
                                                                     userInfo:@{BattlegroundsCardOptionsMenuFactoryStorableMenuItemOptionTypeKey: type,
                                                                                BattlegroundsCardOptionsMenuFactoryStorableMenuItemValueKey: @"",
                                                                                BattlegroundsCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: [NSNumber numberWithBool:showEmptyItem],
                                                                                BattlegroundsCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:type]]}];
        emptyItem.target = target;
        
        [arr insertObject:emptyItem atIndex:0];
        [emptyItem release];
        
        NSMenuItem *separatorItem = [NSMenuItem separatorItem];
        [arr insertObject:separatorItem atIndex:1];
    }
    
    return [arr autorelease];
}

- (NSMenuItem *)searchFieldItemWithOptionType:(BlizzardHSAPIOptionType)optionType
                          searchFieldDelegate:(nonnull id<NSSearchFieldDelegate>)searchFieldDelegate {
    StorableMenuItem *item = [[StorableMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@"" userInfo:@{BattlegroundsCardOptionsMenuFactoryStorableMenuItemOptionTypeKey: optionType,
                                                                                                                 BattlegroundsCardOptionsMenuFactoryStorableMenuItemValueKey: @"",
                                                                                                                 BattlegroundsCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: @NO,
                                                                                                                 BattlegroundsCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:optionType]]}];
    StorableSearchField *searchField = [[StorableSearchField alloc] initWithUserInfo:@{optionType: @""}];
    
    searchField.frame = CGRectMake(0, 0, 300, 20);
    searchField.delegate = searchFieldDelegate;
    
    item.view = searchField;
    
    [searchField release];
    return [item autorelease];
}

- (void)load {
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
        
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *slugsAndIds = [self.hsMetaDataUseCase battlegroundsOptionTypesAndSlugsAndIdsUsingHSMetaData:hsMetaData];
        NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *slugsAndNames = [self.hsMetaDataUseCase battlegroundsOptionTypesAndSlugsAndNamesUsingHSMetaData:hsMetaData];
        
        HSCardType *heroHSCardType = [self.hsMetaDataUseCase hsCardTypeFromTypeSlug:HSCardTypeSlugTypeHero usingHSMetaData:hsMetaData];
        HSCardType *minionHSCardType = [self.hsMetaDataUseCase hsCardTypeFromTypeSlug:HSCardTypeSlugTypeMinion usingHSMetaData:hsMetaData];
        
        NSDictionary<NSString *, NSNumber *> *typeSlugsAndIds = @{heroHSCardType.slug: heroHSCardType.typeId,
                                                                  minionHSCardType.slug: minionHSCardType.typeId};
        NSDictionary<NSString *, NSString *> *typeSlugsAndNames = @{heroHSCardType.slug: heroHSCardType.name,
                                                                    minionHSCardType.slug: minionHSCardType.name};
        
        [hsMetaData release];
        
        [self->_slugsAndIds release];
        self->_slugsAndIds = [slugsAndIds copy];
        
        [self->_slugsAndNames release];
        self->_slugsAndNames = [slugsAndNames copy];
        
        [self->_typeSlugsAndIds release];
        self->_typeSlugsAndIds = [typeSlugsAndIds copy];
        
        [self->_typeSlugsAndNames release];
        self->_typeSlugsAndNames = [typeSlugsAndNames copy];
        
        [self postShouldUpdateItems];
    }];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(hsMetaDataClearCacheReceived:)
                                               name:NSNotificationNameHSMetaDataUseCaseClearCache
                                             object:nil];
}

- (void)hsMetaDataClearCacheReceived:(NSNotification *)notification {
    [self load];
}

- (void)postShouldUpdateItems {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameBattlegroundsCardOptionsMenuFactoryShouldUpdateItems
                                                      object:self
                                                    userInfo:nil];
}

@end
