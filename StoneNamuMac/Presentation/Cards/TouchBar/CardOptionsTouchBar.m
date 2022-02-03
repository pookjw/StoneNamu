//
//  CardOptionsTouchBar.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import "CardOptionsTouchBar.h"
#import "NSTouchBarItemIdentifierCardOptionType+BlizzardHSAPIOptionType.h"
#import "NSScrubber+Private.h"
#import "CardOptionsMenuFactory.h"
#import <StoneNamuResources/StoneNamuResources.h>

static NSTouchBarCustomizationIdentifier const NSTouchBarCustomizationIdentifierCardOptionsTouchBar = @"NSTouchBarCustomizationIdentifierCardOptionsTouchBar";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier = @"NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier";

@interface CardOptionsTouchBar () <NSTouchBarDelegate, NSScrubberDataSource, NSScrubberDelegate>
@property (assign) id<CardOptionsTouchBarDelegate> cardOptionsTouchBarDelegate;
@property (retain) NSMutableDictionary<NSString *, NSSet<NSString *> *> *options;

@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSPopoverTouchBarItem *> *allPopoverItems;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSTouchBar *> *allTouchBars;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSCustomTouchBarItem *> *allCustomTouchBarItems;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSScrubber *> *allScrubbers;
@end

@implementation CardOptionsTouchBar

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options cardOptionsTouchBarDelegate:(id<CardOptionsTouchBarDelegate>)cardOptionsTouchBarDelegate {
    self = [self init];
    
    if (self) {
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        self.cardOptionsTouchBarDelegate = cardOptionsTouchBarDelegate;
        
        [self configureTouchBarItems];
        [self setAttributes];
        [self updateItemsWithOptions:options];
    }
    
    return self;
}

- (void)dealloc {
    [_options release];
    [_allPopoverItems release];
    [_allTouchBars release];
    [_allCustomTouchBarItems release];
    [_allScrubbers release];
    [super dealloc];
}

- (void)setAttributes {
    self.delegate = self;
    self.customizationIdentifier = NSTouchBarCustomizationIdentifierCardOptionsTouchBar;
    self.defaultItemIdentifiers = allNSTouchBarItemIdentifierCardOptionTypes();
    self.customizationAllowedItemIdentifiers = allNSTouchBarItemIdentifierCardOptionTypes();
}

- (void)configureTouchBarItems {
    NSPopoverTouchBarItem *optionTypeSetPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeSet];
    NSTouchBar *optionTypeSetTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeSetItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeSet];
    NSScrubber *optionTypeSetScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeSetPopoverItem
                          touchBar:optionTypeSetTouchBar
                        customItem:optionTypeSetItem
                          scrubber:optionTypeSetScrubber
                          itemSize:CGSizeMake(230.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeSet];
    
    //
    
    NSPopoverTouchBarItem *optionTypeClassPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeClass];
    NSTouchBar *optionTypeClassTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeClassItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeClass];
    NSScrubber *optionTypeClassScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeClassPopoverItem
                          touchBar:optionTypeClassTouchBar
                        customItem:optionTypeClassItem
                          scrubber:optionTypeClassScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeClass];
    
    //
    
    NSPopoverTouchBarItem *optionTypeManaCostPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeManaCost];
    NSTouchBar *optionTypeManaCostTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeManaCostItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeManaCost];
    NSScrubber *optionTypeManaCostScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeManaCostPopoverItem
                          touchBar:optionTypeManaCostTouchBar
                        customItem:optionTypeManaCostItem
                          scrubber:optionTypeManaCostScrubber
                          itemSize:CGSizeMake(50.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeManaCost];
    
    //
    
    NSPopoverTouchBarItem *optionTypeAttackPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeAttack];
    NSTouchBar *optionTypeAttackTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeAttackItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeAttack];
    NSScrubber *optionTypeAttackScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeAttackPopoverItem
                          touchBar:optionTypeAttackTouchBar
                        customItem:optionTypeAttackItem
                          scrubber:optionTypeAttackScrubber
                          itemSize:CGSizeMake(50.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeAttack];
    
    //
    
    NSPopoverTouchBarItem *optionTypeHealthPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeHealth];
    NSTouchBar *optionTypeHealthTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeHealthItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeHealth];
    NSScrubber *optionTypeHealthScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeHealthPopoverItem
                          touchBar:optionTypeHealthTouchBar
                        customItem:optionTypeHealthItem
                          scrubber:optionTypeHealthScrubber
                          itemSize:CGSizeMake(50.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeHealth];
    
    //
    
    NSPopoverTouchBarItem *optionTypeCollectiblePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeCollecticle];
    NSTouchBar *optionTypeCollectibleTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeCollectibleItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeCollecticle];
    NSScrubber *optionTypeCollectibleScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeCollectiblePopoverItem
                          touchBar:optionTypeCollectibleTouchBar
                        customItem:optionTypeCollectibleItem
                          scrubber:optionTypeCollectibleScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeCollectible];
    
    //
    
    NSPopoverTouchBarItem *optionTypeRarityPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeRarity];
    NSTouchBar *optionTypeRarityTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeRarityItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeRarity];
    NSScrubber *optionTypeRarityScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeRarityPopoverItem
                          touchBar:optionTypeRarityTouchBar
                        customItem:optionTypeRarityItem
                          scrubber:optionTypeRarityScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeRarity];
    
    //
    
    NSPopoverTouchBarItem *optionTypeTypePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeType];
    NSTouchBar *optionTypeTypeTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeTypeItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeType];
    NSScrubber *optionTypeTypeScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeTypePopoverItem
                          touchBar:optionTypeTypeTouchBar
                        customItem:optionTypeTypeItem
                          scrubber:optionTypeTypeScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeType];
    
    //
    
    NSPopoverTouchBarItem *optionTypeMinionTypePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeMinionType];
    NSTouchBar *optionTypeMinionTypeTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeMinionTypeItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeMinionType];
    NSScrubber *optionTypeMinionTypeScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeMinionTypePopoverItem
                          touchBar:optionTypeMinionTypeTouchBar
                        customItem:optionTypeMinionTypeItem
                          scrubber:optionTypeMinionTypeScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeMinionType];
    
    //
    
    NSPopoverTouchBarItem *optionTypeSpellSchoolPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeSchoolSpell];
    NSTouchBar *optionTypeSpellSchoolTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeSpellSchoolItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeSchoolSpell];
    NSScrubber *optionTypeSpellSchoolScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeSpellSchoolPopoverItem
                          touchBar:optionTypeSpellSchoolTouchBar
                        customItem:optionTypeSpellSchoolItem
                          scrubber:optionTypeSpellSchoolScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeSpellSchool];
    
    //
    
    NSPopoverTouchBarItem *optionTypeKeywordPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeKeyword];
    NSTouchBar *optionTypeKeywordTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeKeywordItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeKeyword];
    NSScrubber *optionTypeKeywordScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeKeywordPopoverItem
                          touchBar:optionTypeKeywordTouchBar
                        customItem:optionTypeKeywordItem
                          scrubber:optionTypeKeywordScrubber
                          itemSize:CGSizeMake(180.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeKeyword];
    
    //
    
    NSPopoverTouchBarItem *optionTypeGameModePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeGameMode];
    NSTouchBar *optionTypeGameModeTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeGameModeItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeGameMode];
    NSScrubber *optionTypeGameModeScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeGameModePopoverItem
                          touchBar:optionTypeGameModeTouchBar
                        customItem:optionTypeGameModeItem
                          scrubber:optionTypeGameModeScrubber
                          itemSize:CGSizeMake(180.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeGameMode];
    
    //
    
    NSPopoverTouchBarItem *optionTypeSortPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeSort];
    NSTouchBar *optionTypeSortTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeSortItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionTypeSort];
    NSScrubber *optionTypeSortScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeSortPopoverItem
                          touchBar:optionTypeSortTouchBar
                        customItem:optionTypeSortItem
                          scrubber:optionTypeSortScrubber
                          itemSize:CGSizeMake(200.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeSort];
    
    //
    
    self.allPopoverItems = @{
        BlizzardHSAPIOptionTypeSet: optionTypeSetPopoverItem,
        BlizzardHSAPIOptionTypeClass: optionTypeClassPopoverItem,
        BlizzardHSAPIOptionTypeManaCost: optionTypeManaCostPopoverItem,
        BlizzardHSAPIOptionTypeAttack: optionTypeAttackPopoverItem,
        BlizzardHSAPIOptionTypeHealth: optionTypeHealthPopoverItem,
        BlizzardHSAPIOptionTypeCollectible: optionTypeCollectiblePopoverItem,
        BlizzardHSAPIOptionTypeRarity: optionTypeRarityPopoverItem,
        BlizzardHSAPIOptionTypeType: optionTypeTypePopoverItem,
        BlizzardHSAPIOptionTypeMinionType: optionTypeMinionTypePopoverItem,
        BlizzardHSAPIOptionTypeSpellSchool: optionTypeSpellSchoolPopoverItem,
        BlizzardHSAPIOptionTypeKeyword: optionTypeKeywordPopoverItem,
        BlizzardHSAPIOptionTypeGameMode: optionTypeGameModePopoverItem,
        BlizzardHSAPIOptionTypeSort: optionTypeSortPopoverItem
    };
    
    self.allTouchBars = @{
        BlizzardHSAPIOptionTypeSet: optionTypeSetTouchBar,
        BlizzardHSAPIOptionTypeClass: optionTypeClassTouchBar,
        BlizzardHSAPIOptionTypeManaCost: optionTypeManaCostTouchBar,
        BlizzardHSAPIOptionTypeAttack: optionTypeAttackTouchBar,
        BlizzardHSAPIOptionTypeHealth: optionTypeHealthTouchBar,
        BlizzardHSAPIOptionTypeCollectible: optionTypeCollectibleTouchBar,
        BlizzardHSAPIOptionTypeRarity: optionTypeRarityTouchBar,
        BlizzardHSAPIOptionTypeType: optionTypeTypeTouchBar,
        BlizzardHSAPIOptionTypeMinionType: optionTypeMinionTypeTouchBar,
        BlizzardHSAPIOptionTypeSpellSchool: optionTypeSpellSchoolTouchBar,
        BlizzardHSAPIOptionTypeKeyword: optionTypeKeywordTouchBar,
        BlizzardHSAPIOptionTypeGameMode: optionTypeGameModeTouchBar,
        BlizzardHSAPIOptionTypeSort: optionTypeSortTouchBar
    };
    
    self.allCustomTouchBarItems = @{
        BlizzardHSAPIOptionTypeSet: optionTypeSetItem,
        BlizzardHSAPIOptionTypeClass: optionTypeClassItem,
        BlizzardHSAPIOptionTypeManaCost: optionTypeManaCostItem,
        BlizzardHSAPIOptionTypeAttack: optionTypeAttackItem,
        BlizzardHSAPIOptionTypeHealth: optionTypeHealthItem,
        BlizzardHSAPIOptionTypeCollectible: optionTypeCollectibleItem,
        BlizzardHSAPIOptionTypeRarity: optionTypeRarityItem,
        BlizzardHSAPIOptionTypeType: optionTypeTypeItem,
        BlizzardHSAPIOptionTypeMinionType: optionTypeMinionTypeItem,
        BlizzardHSAPIOptionTypeSpellSchool: optionTypeSpellSchoolItem,
        BlizzardHSAPIOptionTypeKeyword: optionTypeKeywordItem,
        BlizzardHSAPIOptionTypeGameMode: optionTypeKeywordItem,
        BlizzardHSAPIOptionTypeSort: optionTypeSortItem
    };
    
    self.allScrubbers = @{
        BlizzardHSAPIOptionTypeSet: optionTypeSetScrubber,
        BlizzardHSAPIOptionTypeClass: optionTypeClassScrubber,
        BlizzardHSAPIOptionTypeManaCost: optionTypeManaCostScrubber,
        BlizzardHSAPIOptionTypeAttack: optionTypeAttackScrubber,
        BlizzardHSAPIOptionTypeHealth: optionTypeHealthScrubber,
        BlizzardHSAPIOptionTypeCollectible: optionTypeCollectibleScrubber,
        BlizzardHSAPIOptionTypeRarity: optionTypeRarityScrubber,
        BlizzardHSAPIOptionTypeType: optionTypeTypeScrubber,
        BlizzardHSAPIOptionTypeMinionType: optionTypeMinionTypeScrubber,
        BlizzardHSAPIOptionTypeSpellSchool: optionTypeSpellSchoolScrubber,
        BlizzardHSAPIOptionTypeKeyword: optionTypeKeywordScrubber,
        BlizzardHSAPIOptionTypeGameMode: optionTypeGameModeScrubber,
        BlizzardHSAPIOptionTypeSort: optionTypeSortScrubber
    };
    
    //
    
    [optionTypeSetPopoverItem release];
    [optionTypeSetTouchBar release];
    [optionTypeSetItem release];
    [optionTypeSetScrubber release];
    
    [optionTypeClassPopoverItem release];
    [optionTypeClassTouchBar release];
    [optionTypeClassItem release];
    [optionTypeClassScrubber release];
    
    [optionTypeManaCostPopoverItem release];
    [optionTypeManaCostTouchBar release];
    [optionTypeManaCostItem release];
    [optionTypeManaCostScrubber release];
    
    [optionTypeAttackPopoverItem release];
    [optionTypeAttackTouchBar release];
    [optionTypeAttackItem release];
    [optionTypeAttackScrubber release];
    
    [optionTypeHealthPopoverItem release];
    [optionTypeHealthTouchBar release];
    [optionTypeHealthItem release];
    [optionTypeHealthScrubber release];
    
    [optionTypeCollectiblePopoverItem release];
    [optionTypeCollectibleTouchBar release];
    [optionTypeCollectibleItem release];
    [optionTypeCollectibleScrubber release];
    
    [optionTypeRarityPopoverItem release];
    [optionTypeRarityTouchBar release];
    [optionTypeRarityItem release];
    [optionTypeRarityScrubber release];
    
    [optionTypeTypePopoverItem release];
    [optionTypeTypeTouchBar release];
    [optionTypeTypeItem release];
    [optionTypeTypeScrubber release];
    
    [optionTypeMinionTypePopoverItem release];
    [optionTypeMinionTypeTouchBar release];
    [optionTypeMinionTypeItem release];
    [optionTypeMinionTypeScrubber release];
    
    [optionTypeSpellSchoolPopoverItem release];
    [optionTypeSpellSchoolTouchBar release];
    [optionTypeSpellSchoolItem release];
    [optionTypeSpellSchoolScrubber release];
    
    [optionTypeKeywordPopoverItem release];
    [optionTypeKeywordTouchBar release];
    [optionTypeKeywordItem release];
    [optionTypeKeywordScrubber release];
    
    [optionTypeGameModePopoverItem release];
    [optionTypeGameModeTouchBar release];
    [optionTypeGameModeItem release];
    [optionTypeGameModeScrubber release];
    
    [optionTypeSortPopoverItem release];
    [optionTypeSortTouchBar release];
    [optionTypeSortItem release];
    [optionTypeSortScrubber release];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> *)options {
    if ([options isEqualToDictionary:self.options]) return;
    
    NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
    self.options = mutableOptions;
    [mutableOptions release];
    
    //
    
    [self.allPopoverItems enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType _Nonnull key, NSPopoverTouchBarItem * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.collapsedRepresentationImage = [CardOptionsMenuFactory imageForCardOptionTypeWithValues:options[key] optionType:key];
    }];
    
    [self.allScrubbers enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType _Nonnull key, NSScrubber * _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([CardOptionsMenuFactory supportsMultipleSelectionFromOptionType:key]) {
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
            
            if (oldIndex != newIndex) {
                [obj scrollItemAtIndex:newIndex toAlignment:NSScrubberAlignmentCenter animated:YES];
                [obj setSelectedIndex:newIndex animated:YES];
            }
        }
    }];
}

- (void)wireItemsWithPopoverItem:(NSPopoverTouchBarItem *)popoverItem
                        touchBar:(NSTouchBar *)touchBar
                      customItem:(NSCustomTouchBarItem *)customItem
                        scrubber:(NSScrubber *)scrubber
                        itemSize:(CGSize)itemSize
                      optionType:(BlizzardHSAPIOptionType)optionType {
    
    NSSet<NSString *> * _Nullable values = self.options[optionType];
    BOOL supportsMultipleSelection = [CardOptionsMenuFactory supportsMultipleSelectionFromOptionType:optionType];
    
    popoverItem.collapsedRepresentationImage = [CardOptionsMenuFactory imageForCardOptionTypeWithValues:values optionType:optionType];
    popoverItem.collapsedRepresentationLabel = [CardOptionsMenuFactory titleForOptionType:optionType];
    popoverItem.customizationLabel = [CardOptionsMenuFactory titleForOptionType:optionType];
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

#pragma mark - Helper

- (BOOL)hasEmptyRowAtScrubber:(NSScrubber *)scrubber {
    BlizzardHSAPIOptionType _Nullable optionType = [self.allScrubbers allKeysForObject:scrubber].firstObject;
    
    if (optionType == nil) return NO;
    
    return [CardOptionsMenuFactory hasEmptyItemAtOptionType:optionType];
}

- (NSDictionary<NSString *, NSString *> * _Nullable)dicFromScrubber:(NSScrubber *)scrubber {
    NSMutableDictionary<NSString *, NSString *> * _Nullable mutableDic = nil;
    NSArray<NSString *> * _Nullable filterKeys = nil;
    
    BlizzardHSAPIOptionType _Nullable optionType = [self.allScrubbers allKeysForObject:scrubber].firstObject;
    
    if (optionType == nil) return nil;
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        mutableDic = [[ResourcesService localizationsForHSCardSet] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        mutableDic = [[ResourcesService localizationsForHSCardClass] mutableCopy];
        filterKeys = @[NSStringFromHSCardClass(HSCardClassDeathKnight)];
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
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        mutableDic = [[ResourcesService localizationsForHSCardCollectible] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        mutableDic = [[ResourcesService localizationsForHSCardRarity] mutableCopy];
        filterKeys = @[NSStringFromHSCardRarity(HSCardRarityNull)];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        mutableDic = [[ResourcesService localizationsForHSCardType] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        mutableDic = [[ResourcesService localizationsForHSCardMinionType] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        mutableDic = [[ResourcesService localizationsForHSCardSpellSchool] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        mutableDic = [[ResourcesService localizationsForHSCardKeyword] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        mutableDic = [[ResourcesService localizationsForHSCardGameMode] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        mutableDic = [[ResourcesService localizationsForHSCardSort] mutableCopy];
        filterKeys = nil;
    }
    
    //
    
    if ([self hasEmptyRowAtScrubber:scrubber]) {
        mutableDic[@""] = [ResourcesService localizationForKey:LocalizableKeyAll];
    }
    
    if (filterKeys == nil) {
        return [mutableDic autorelease];
    } else {
        NSMutableDictionary<NSString *, NSString *> *result = [@{} mutableCopy];
        
        [mutableDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            if (![filterKeys containsString:key]) {
                result[key] = obj;
            }
        }];
        
        [mutableDic release];
        
        return [result autorelease];
    }
}

- (NSArray<NSString *> * _Nullable)sortedKeysFromScrubber:(NSScrubber *)scrubber {
    BlizzardHSAPIOptionType _Nullable optionType = [self.allScrubbers allKeysForObject:scrubber].firstObject;
    
    if (optionType == nil) return nil;
    
    NSDictionary<NSString *, NSString *> * _Nullable dic = [self dicFromScrubber:scrubber];
    NSUInteger (^__block converter)(NSString *);
    BOOL ascending = YES;
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        converter = ^NSUInteger(NSString * key) {
            return HSCardSetFromNSString(key);
        };
        ascending = NO;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        converter = ^NSUInteger(NSString * key) {
            return HSCardClassFromNSString(key);
        };
        ascending = YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost] || [optionType isEqualToString:BlizzardHSAPIOptionTypeAttack] || [optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        converter = ^NSUInteger(NSString *key) {
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSUInteger value = [formatter numberFromString:key].unsignedIntegerValue;
            [formatter release];
            return value;
        };
        ascending = YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        converter = ^NSUInteger(NSString * key) {
            return HSCardCollectibleFromNSString(key);
        };
        ascending = YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardRarityFromNSString(key);
        };
        ascending = YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardTypeFromNSString(key);
        };
        ascending = YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardMinionTypeFromNSString(key);
        };
        ascending = YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardSpellSchoolFromNSString(key);
        };
        ascending = YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardKeywordFromNSString(key);
        };
        ascending = YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardGameModeFromNSString(key);
        };
        ascending = YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardSortFromNSString(key);
        };
        ascending = YES;
    }
    
    NSMutableArray<NSString *> *keys = [[dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        HSCardSet lhs = converter(obj1);
        HSCardSet rhs = converter(obj2);
        
        if (lhs < rhs) {
            if (ascending) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        } else if (lhs > rhs) {
            if (ascending) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        } else {
            return NSOrderedSame;
        }
    }] mutableCopy];
    
    //
    
    [keys removeSingleString:@""];
    if ([self hasEmptyRowAtScrubber:scrubber]) {
        [keys insertObject:@"" atIndex:0];
    }
    
    //
    
    return [keys autorelease];
}

#pragma mark - NSTouchBarDelegate

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    if ([touchBar isEqual:self]) {
        NSTouchBarItem * _Nullable __block result = nil;
        
        [self.allPopoverItems enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType  _Nonnull key, NSPopoverTouchBarItem * _Nonnull obj, BOOL * _Nonnull stop) {
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
    
    if ((optionType != nil) && ([CardOptionsMenuFactory supportsMultipleSelectionFromOptionType:optionType])) {
        NSSet<NSString *> * _Nullable values = self.options[optionType];
        BOOL hasValue = [CardOptionsMenuFactory hasValueForValues:values];
        
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
    BlizzardHSAPIOptionType _Nullable key = [self.allScrubbers allKeysForObject:scrubber].firstObject;
    
    if (key == nil) return;
    
    BOOL showsEmptyItem = [CardOptionsMenuFactory hasEmptyItemAtOptionType:key];
    BOOL supportsMultipleSelection = [CardOptionsMenuFactory supportsMultipleSelectionFromOptionType:key];
    
    NSArray<NSString *> *values = [self sortedKeysFromScrubber:scrubber];
    NSString *value = values[selectedIndex];
    
    NSMutableDictionary<NSString *, NSSet<NSString *> *> *newOptions = [self.options mutableCopy];
    
    if ([value isEqualToString:@""]) {
        [newOptions removeObjectForKey:key];
    } else if (!supportsMultipleSelection) {
        newOptions[key] = [NSSet setWithObject:value];
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
//            [newOptions removeObjectForKey:key];
        }
        
        [values release];
    }
    
    if (![self.options isEqualToDictionary:newOptions]) {
        [self updateItemsWithOptions:newOptions];
        [self.cardOptionsTouchBarDelegate cardOptionsTouchBar:self changedOption:newOptions];
    }
    
    [newOptions release];
}

@end
