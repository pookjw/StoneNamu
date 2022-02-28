//
//  BattlegroundsCardOptionsTouchBar.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import "BattlegroundsCardOptionsTouchBar.h"
#import "NSTouchBarItemIdentifierBattlegroundsCardOptionType+BlizzardHSAPIOptionType.h"
#import "NSScrubber+Private.h"
#import "BattlegroundsCardOptionsMenuFactory.h"
#import <StoneNamuResources/StoneNamuResources.h>

static NSTouchBarCustomizationIdentifier const NSTouchBarCustomizationIdentifierBattlegroundsCardOptionsTouchBar = @"NSTouchBarCustomizationIdentifierBattlegroundsCardOptionsTouchBar";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier = @"NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier";

@interface BattlegroundsCardOptionsTouchBar () <NSTouchBarDelegate, NSScrubberDataSource, NSScrubberDelegate>
@property (assign) id<BattlegroundsCardOptionsTouchBarDelegate> battlegroundsCardOptionsTouchBarDelegate;
@property (retain) BattlegroundsCardOptionsMenuFactory *factory;
@property (retain) NSOperationQueue *queue;

@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSPopoverTouchBarItem *> *allPopoverItems;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSTouchBar *> *allTouchBars;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSCustomTouchBarItem *> *allCustomTouchBarItems;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSScrubber *> *allScrubbers;
@property (retain) NSMutableDictionary<NSString *, NSSet<NSString *> *> *options;
@end

@implementation BattlegroundsCardOptionsTouchBar

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options battlegroundsCardOptionsTouchBarDelegate:(id<BattlegroundsCardOptionsTouchBarDelegate>)battlegroundsCardOptionsTouchBarDelegate {
    self = [self init];
    
    if (self) {
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        BattlegroundsCardOptionsMenuFactory *factory = [BattlegroundsCardOptionsMenuFactory new];
        self.factory = factory;
        [factory release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        self.battlegroundsCardOptionsTouchBarDelegate = battlegroundsCardOptionsTouchBarDelegate;
        
        [self configureTouchBarItems];
        [self setAttributes];
        [self updateItemsWithOptions:options];
        [self bind];
        [self.factory load];
    }
    
    return self;
}

- (void)dealloc {
    [_factory release];
    [_queue release];
    [_allPopoverItems release];
    [_allTouchBars release];
    [_allCustomTouchBarItems release];
    [_allScrubbers release];
    [_options release];
    [super dealloc];
}

- (void)setAttributes {
    self.delegate = self;
    self.customizationIdentifier = NSTouchBarCustomizationIdentifierBattlegroundsCardOptionsTouchBar;
    self.defaultItemIdentifiers = allNSTouchBarItemIdentifierBattlegroundsCardOptionTypes();
    self.customizationAllowedItemIdentifiers = allNSTouchBarItemIdentifierBattlegroundsCardOptionTypes();
}

- (void)configureTouchBarItems {
    NSPopoverTouchBarItem *optionTypeTierPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeTier];
    NSTouchBar *optionTypeTierTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeTierItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeTier];
    NSScrubber *optionTypeTierScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeTierPopoverItem
                          touchBar:optionTypeTierTouchBar
                        customItem:optionTypeTierItem
                          scrubber:optionTypeTierScrubber
                          itemSize:CGSizeMake(50.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeTier];
    
    //
    
    NSPopoverTouchBarItem *optionTypeAttackPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeAttack];
    NSTouchBar *optionTypeAttackTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeAttackItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeAttack];
    NSScrubber *optionTypeAttackScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeAttackPopoverItem
                          touchBar:optionTypeAttackTouchBar
                        customItem:optionTypeAttackItem
                          scrubber:optionTypeAttackScrubber
                          itemSize:CGSizeMake(50.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeAttack];
    
    //
    
    NSPopoverTouchBarItem *optionTypeHealthPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeHealth];
    NSTouchBar *optionTypeHealthTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeHealthItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeHealth];
    NSScrubber *optionTypeHealthScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeHealthPopoverItem
                          touchBar:optionTypeHealthTouchBar
                        customItem:optionTypeHealthItem
                          scrubber:optionTypeHealthScrubber
                          itemSize:CGSizeMake(50.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeHealth];
    
    //
    
    NSPopoverTouchBarItem *optionTypeTypePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeType];
    NSTouchBar *optionTypeTypeTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeTypeItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeType];
    NSScrubber *optionTypeTypeScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeTypePopoverItem
                          touchBar:optionTypeTypeTouchBar
                        customItem:optionTypeTypeItem
                          scrubber:optionTypeTypeScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeType];
    
    //
    
    NSPopoverTouchBarItem *optionTypeMinionTypePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeMinionType];
    NSTouchBar *optionTypeMinionTypeTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeMinionTypeItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeMinionType];
    NSScrubber *optionTypeMinionTypeScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeMinionTypePopoverItem
                          touchBar:optionTypeMinionTypeTouchBar
                        customItem:optionTypeMinionTypeItem
                          scrubber:optionTypeMinionTypeScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeMinionType];
    
    //
    
    NSPopoverTouchBarItem *optionTypeKeywordPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeKeyword];
    NSTouchBar *optionTypeKeywordTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeKeywordItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeKeyword];
    NSScrubber *optionTypeKeywordScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeKeywordPopoverItem
                          touchBar:optionTypeKeywordTouchBar
                        customItem:optionTypeKeywordItem
                          scrubber:optionTypeKeywordScrubber
                          itemSize:CGSizeMake(180.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeKeyword];
    
    //
    
    NSPopoverTouchBarItem *optionTypeSortPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeSort];
    NSTouchBar *optionTypeSortTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeSortItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeSort];
    NSScrubber *optionTypeSortScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeSortPopoverItem
                          touchBar:optionTypeSortTouchBar
                        customItem:optionTypeSortItem
                          scrubber:optionTypeSortScrubber
                          itemSize:CGSizeMake(200.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeSort];
    
    //
    
    self.allPopoverItems = @{
        BlizzardHSAPIOptionTypeTier: optionTypeTierPopoverItem,
        BlizzardHSAPIOptionTypeAttack: optionTypeAttackPopoverItem,
        BlizzardHSAPIOptionTypeHealth: optionTypeHealthPopoverItem,
        BlizzardHSAPIOptionTypeType: optionTypeTypePopoverItem,
        BlizzardHSAPIOptionTypeMinionType: optionTypeMinionTypePopoverItem,
        BlizzardHSAPIOptionTypeKeyword: optionTypeKeywordPopoverItem,
        BlizzardHSAPIOptionTypeSort: optionTypeSortPopoverItem
    };
    
    self.allTouchBars = @{
        BlizzardHSAPIOptionTypeTier: optionTypeTierTouchBar,
        BlizzardHSAPIOptionTypeAttack: optionTypeAttackTouchBar,
        BlizzardHSAPIOptionTypeHealth: optionTypeHealthTouchBar,
        BlizzardHSAPIOptionTypeType: optionTypeTypeTouchBar,
        BlizzardHSAPIOptionTypeMinionType: optionTypeMinionTypeTouchBar,
        BlizzardHSAPIOptionTypeKeyword: optionTypeKeywordTouchBar,
        BlizzardHSAPIOptionTypeSort: optionTypeSortTouchBar
    };
    
    self.allCustomTouchBarItems = @{
        BlizzardHSAPIOptionTypeTier: optionTypeTierItem,
        BlizzardHSAPIOptionTypeAttack: optionTypeAttackItem,
        BlizzardHSAPIOptionTypeHealth: optionTypeHealthItem,
        BlizzardHSAPIOptionTypeType: optionTypeTypeItem,
        BlizzardHSAPIOptionTypeMinionType: optionTypeMinionTypeItem,
        BlizzardHSAPIOptionTypeKeyword: optionTypeKeywordItem,
        BlizzardHSAPIOptionTypeSort: optionTypeSortItem
    };
    
    self.allScrubbers = @{
        BlizzardHSAPIOptionTypeTier: optionTypeTierScrubber,
        BlizzardHSAPIOptionTypeAttack: optionTypeAttackScrubber,
        BlizzardHSAPIOptionTypeHealth: optionTypeHealthScrubber,
        BlizzardHSAPIOptionTypeType: optionTypeTypeScrubber,
        BlizzardHSAPIOptionTypeMinionType: optionTypeMinionTypeScrubber,
        BlizzardHSAPIOptionTypeKeyword: optionTypeKeywordScrubber,
        BlizzardHSAPIOptionTypeSort: optionTypeSortScrubber
    };
    
    //
    
    [optionTypeTierPopoverItem release];
    [optionTypeTierTouchBar release];
    [optionTypeTierItem release];
    [optionTypeTierScrubber release];
    
    [optionTypeAttackPopoverItem release];
    [optionTypeAttackTouchBar release];
    [optionTypeAttackItem release];
    [optionTypeAttackScrubber release];
    
    [optionTypeHealthPopoverItem release];
    [optionTypeHealthTouchBar release];
    [optionTypeHealthItem release];
    [optionTypeHealthScrubber release];
    
    [optionTypeTypePopoverItem release];
    [optionTypeTypeTouchBar release];
    [optionTypeTypeItem release];
    [optionTypeTypeScrubber release];
    
    [optionTypeMinionTypePopoverItem release];
    [optionTypeMinionTypeTouchBar release];
    [optionTypeMinionTypeItem release];
    [optionTypeMinionTypeScrubber release];
    
    [optionTypeKeywordPopoverItem release];
    [optionTypeKeywordTouchBar release];
    [optionTypeKeywordItem release];
    [optionTypeKeywordScrubber release];
    
    [optionTypeSortPopoverItem release];
    [optionTypeSortTouchBar release];
    [optionTypeSortItem release];
    [optionTypeSortScrubber release];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> *)options {
    [self updateItemsWithOptions:options force:NO];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> *)options force:(BOOL)force {
    [self.queue addBarrierBlock:^{
        if (!force) {
            if (compareNullableValues(self.options, options, @selector(isEqualToDictionary:))) return;
        }
        
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        //
        
        [self.allPopoverItems enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType _Nonnull key, NSPopoverTouchBarItem * _Nonnull obj, BOOL * _Nonnull stop) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                obj.collapsedRepresentationImage = [self.factory imageForCardOptionTypeWithValues:options[key] optionType:key];
            }];
        }];
        
        [self.allScrubbers enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType _Nonnull key, NSScrubber * _Nonnull obj, BOOL * _Nonnull stop) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                if ([self.factory supportsMultipleSelectionFromOptionType:key]) {
                    // TODO
                    [obj reloadData];
                } else {
                    NSArray<NSString *> *keys = [self sortedKeysFromScrubber:obj];
                    
                    if (keys.count == 0) return;
                    
                    NSSet<NSString *> * _Nullable values = options[key];
                    
                    NSInteger oldIndex = obj.selectedIndex;
                    NSInteger newIndex;
                    
                    if (values == nil) {
                        newIndex = [keys indexOfString:@""];
                    } else {
                        newIndex = [keys indexOfString:values.allObjects.firstObject];
                    }
                    
                    if ((oldIndex != newIndex) || (force)) {
                        [obj scrollItemAtIndex:newIndex toAlignment:NSScrubberAlignmentCenter animated:YES];
                        [obj setSelectedIndex:newIndex animated:YES];
                    }
                }
            }];
        }];
    }];
}

- (void)wireItemsWithPopoverItem:(NSPopoverTouchBarItem *)popoverItem
                        touchBar:(NSTouchBar *)touchBar
                      customItem:(NSCustomTouchBarItem *)customItem
                        scrubber:(NSScrubber *)scrubber
                        itemSize:(CGSize)itemSize
                      optionType:(BlizzardHSAPIOptionType)optionType {
    
    NSSet<NSString *> * _Nullable values = self.options[optionType];
    BOOL supportsMultipleSelection = [self.factory supportsMultipleSelectionFromOptionType:optionType];
    
    popoverItem.collapsedRepresentationImage = [self.factory imageForCardOptionTypeWithValues:values optionType:optionType];
    popoverItem.popoverTouchBar = touchBar;
    popoverItem.pressAndHoldTouchBar = touchBar;
    touchBar.delegate = self;
    touchBar.defaultItemIdentifiers = @[customItem.identifier];
    
    customItem.view = scrubber;
    scrubber.mode = NSScrubberModeFree;
    if (supportsMultipleSelection) {
        scrubber.selectionOverlayStyle = nil;
        scrubber.floatsSelectionViews = NO;
    } else {
        scrubber.selectionOverlayStyle = [NSScrubberSelectionStyle outlineOverlayStyle];
        scrubber.floatsSelectionViews = YES;
    }
    
    scrubber.continuous = NO;
    scrubber.showsArrowButtons = YES;
    [scrubber registerClass:[NSScrubberTextItemView class] forItemIdentifier:NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier];
    scrubber.dataSource = self;
    scrubber.delegate = self;
    
    NSScrubberFlowLayout *scrubberLayout = [NSScrubberFlowLayout new];
    scrubberLayout.itemSize = itemSize;
    scrubber.scrubberLayout = scrubberLayout;
    [scrubberLayout release];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shouldUpdateReceived:)
                                               name:NSNotificationNameBattlegroundsCardOptionsMenuFactoryShouldUpdateItems
                                             object:self.factory];
}

- (void)shouldUpdateReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.allPopoverItems enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType  _Nonnull key, NSPopoverTouchBarItem * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.collapsedRepresentationLabel = [self.factory titleForOptionType:key];
            obj.customizationLabel = [self.factory titleForOptionType:key];
        }];
        
        [self updateItemsWithOptions:self.options force:YES];
    }];
}

#pragma mark - Helper

- (BOOL)hasEmptyRowAtScrubber:(NSScrubber *)scrubber {
    BlizzardHSAPIOptionType _Nullable optionType = [self.allScrubbers allKeysForObject:scrubber].firstObject;
    
    if (optionType == nil) return NO;
    
    return [self.factory hasEmptyItemAtOptionType:optionType];
}

- (NSDictionary<NSString *, NSString *> * _Nullable)dicFromScrubber:(NSScrubber *)scrubber {
    NSMutableDictionary<NSString *, NSString *> * _Nullable mutableDic = nil;
    NSArray<NSString *> * _Nullable filterKeys = nil;
    
    BlizzardHSAPIOptionType _Nullable optionType = [self.allScrubbers allKeysForObject:scrubber].firstObject;
    
    if (optionType == nil) return nil;
    
    //
    
    if ([self.factory isEnabledItemWithOptionType:optionType options:self.options]) {
        if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTier]) {
            mutableDic = [@{@"0": @"0",
                            @"1": @"1",
                            @"2": @"2",
                            @"3": @"3",
                            @"4": @"4",
                            @"5": @"5",
                            @"6": @"6"} mutableCopy];
            filterKeys = nil;
        } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost] || [optionType isEqualToString:BlizzardHSAPIOptionTypeAttack] || [optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
            mutableDic = [@{@"0": @"0",
                            @"1": @"1",
                            @"2": @"2",
                            @"3": @"3",
                            @"4": @"4",
                            @"5": @"5",
                            @"6": @"6",
                            @"7": @"7",
                            @"8": @"8",
                            @"9": @"9",
                            @"10": @"10+"} mutableCopy];
            filterKeys = nil;
        } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
            mutableDic = [self.factory.typeSlugsAndNames mutableCopy];
            filterKeys = nil;
        } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
            mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
            filterKeys = nil;
        } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
            mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
            filterKeys = nil;
        } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
            mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
            filterKeys = nil;
        }
        
        if ([self hasEmptyRowAtScrubber:scrubber]) {
            mutableDic[@""] = [ResourcesService localizationForKey:LocalizableKeyAll];
        }
        
        if (filterKeys == nil) {
            return [mutableDic autorelease];
        } else {
            NSMutableDictionary<NSString *, NSString *> *result = [NSMutableDictionary<NSString *, NSString *> new];
            
            [mutableDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                if (![filterKeys containsString:key]) {
                    result[key] = obj;
                }
            }];
            
            [mutableDic release];
            
            return [result autorelease];
        }
    } else {
        return @{};
    }
}

- (NSArray<NSString *> * _Nullable)sortedKeysFromScrubber:(NSScrubber *)scrubber {
    BlizzardHSAPIOptionType _Nullable optionType = [self.allScrubbers allKeysForObject:scrubber].firstObject;
    
    if (optionType == nil) return nil;
    
    if ([self.factory isEnabledItemWithOptionType:optionType options:self.options]) {
        NSMutableDictionary<NSString *, NSString *> * _Nullable dic = [[self dicFromScrubber:scrubber] mutableCopy];
        [dic removeObjectForKey:@""];
        
        NSComparisonResult (^comparator)(NSString *, NSString *);
        
        if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTier]) {
            comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
                NSNumber *lhsNumber = [NSNumber numberWithInteger:lhs.integerValue];
                NSNumber *rhsNumber = [NSNumber numberWithInteger:rhs.integerValue];
                return [lhsNumber compare:rhsNumber];
            };
        } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost] || [optionType isEqualToString:BlizzardHSAPIOptionTypeAttack] || [optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
            comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
                NSNumber *lhsNumber = [NSNumber numberWithInteger:lhs.integerValue];
                NSNumber *rhsNumber = [NSNumber numberWithInteger:rhs.integerValue];
                return [lhsNumber compare:rhsNumber];
            };
        } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
            comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
                NSString *lhsName = self.factory.typeSlugsAndNames[lhs];
                NSString *rhsName = self.factory.typeSlugsAndNames[rhs];
                return [lhsName compare:rhsName];
            };
        } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
            comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
                NSString *lhsName = self.factory.slugsAndNames[optionType][lhs];
                NSString *rhsName = self.factory.slugsAndNames[optionType][rhs];
                return [lhsName compare:rhsName];
            };
        } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
            comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
                NSString *lhsName = self.factory.slugsAndNames[optionType][lhs];
                NSString *rhsName = self.factory.slugsAndNames[optionType][rhs];
                return [lhsName compare:rhsName];
            };
        } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
            comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
                NSNumber *lhsNumber = [NSNumber numberWithInteger:HSCardSortFromNSString(lhs)];
                NSNumber *rhsNumber = [NSNumber numberWithInteger:HSCardSortFromNSString(rhs)];
                return [lhsNumber compare:rhsNumber];
            };
        } else {
            comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
                return NSOrderedSame;
            };
        }
        
        NSMutableArray<NSString *> *keys = [[dic.allKeys sortedArrayUsingComparator:comparator] mutableCopy];
        [dic release];
        
        //
        
        if ([self hasEmptyRowAtScrubber:scrubber]) {
            [keys insertObject:@"" atIndex:0];
        }
        
        //
        
        return [keys autorelease];
    } else {
        return @[];
    }
}

#pragma mark - NSTouchBarDelegate

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    if ([touchBar isEqual:self]) {
        NSTouchBarItem * _Nullable __block result = nil;
        
        [self.allPopoverItems.allValues enumerateObjectsUsingBlock:^(NSPopoverTouchBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([identifier isEqualToString:obj.identifier]) {
                result = obj;
                *stop = YES;
            }
        }];
        
        return result;
    } else {
        BlizzardHSAPIOptionType _Nullable optionType = [self.allTouchBars allKeysForObject:touchBar].firstObject;
        
        if (optionType == nil) return nil;
        
        return self.allCustomTouchBarItems[optionType];
    }
}

#pragma mark - NSScrubberDataSource

- (NSInteger)numberOfItemsForScrubber:(NSScrubber *)scrubber {
    return [self dicFromScrubber:scrubber].count;
}

- (__kindof NSScrubberItemView *)scrubber:(NSScrubber *)scrubber viewForItemAtIndex:(NSInteger)index {
    NSScrubberTextItemView *item = [scrubber makeItemWithIdentifier:NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier owner:self];
    
    NSDictionary<NSString *, NSString *> *dic = [self dicFromScrubber:scrubber];
    NSArray<NSString *> *keys = [self sortedKeysFromScrubber:scrubber];
    
    NSString *key = keys[index];
    NSString * _Nullable title = dic[key];
    
    if (title != nil) {
        item.title = title;
    } else {
        item.title = @"ERROR";
    }
    
    //
    
    BlizzardHSAPIOptionType _Nullable optionType = [self.allScrubbers allKeysForObject:scrubber].firstObject;
    
    if ((optionType != nil) && ([self.factory supportsMultipleSelectionFromOptionType:optionType])) {
        NSSet<NSString *> * _Nullable values = self.options[optionType];
        BOOL hasValue;
        
        if (values == nil) {
            hasValue = NO;
        } else {
            hasValue = values.hasValuesWhenStringType;
        }
        
        item.wantsLayer = YES;
        item.layer.cornerCurve = kCACornerCurveContinuous;
        item.layer.cornerRadius = 10.0f;
        
        if ((hasValue) && ([values.allObjects containsString:key])) {
            item.layer.backgroundColor = NSColor.grayColor.CGColor;
        } else if ((!hasValue) && ([key isEqualToString:@""])) {
            item.layer.backgroundColor = NSColor.grayColor.CGColor;
        } else {
            item.layer.backgroundColor = NSColor.clearColor.CGColor;
        }
    }
    
    return item;
}

#pragma mark - NSScrubberDelegate

- (void)scrubber:(NSScrubber *)scrubber didSelectItemAtIndex:(NSInteger)selectedIndex {
    [self.queue addBarrierBlock:^{
        BlizzardHSAPIOptionType _Nullable key = [self.allScrubbers allKeysForObject:scrubber].firstObject;
        
        if (key == nil) return;
        
        BOOL showsEmptyItem = [self.factory hasEmptyItemAtOptionType:key];
        BOOL supportsMultipleSelection = [self.factory supportsMultipleSelectionFromOptionType:key];
        
        NSArray<NSString *> *values = [self sortedKeysFromScrubber:scrubber];
        NSString *value = values[selectedIndex];
        
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *newOptions = [self.options mutableCopy];
        
        if ([value isEqualToString:@""]) {
            [newOptions removeObjectForKey:key];
        } else if (!supportsMultipleSelection) {
            NSSet<NSString *> * _Nullable values = newOptions[key];
            
            if ((values == nil) || !([values containsObject:value])) {
                newOptions[key] = [NSSet setWithObject:value];
            } else {
                [newOptions removeObjectForKey:key];
            }
        } else {
            NSMutableSet<NSString *> * _Nullable values = [self.options[key] mutableCopy];
            if (values == nil) {
                values = [NSMutableSet<NSString *> new];
            }
            
            if ([values.allObjects containsString:value]) {
                [values removeObject:value];
            } else {
                [values addObject:value];
            }
            
            if (values.count > 0) {
                newOptions[key] = values;
            } else if (showsEmptyItem) {
                [newOptions removeObjectForKey:key];
            }
            
            [values release];
        }
        
        NSDictionary<NSString *, NSSet<NSString *> *> *validatedOptions = [self.factory validatedOptionsFromOptions:newOptions];
        [newOptions release];
        
        [self updateItemsWithOptions:validatedOptions];
        [self.battlegroundsCardOptionsTouchBarDelegate battlegroundsCardOptionsTouchBar:self changedOption:validatedOptions];
    }];
}

@end
