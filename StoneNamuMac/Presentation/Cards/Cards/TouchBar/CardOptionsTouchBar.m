//
//  CardOptionsTouchBar.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import "CardOptionsTouchBar.h"
#import "NSTouchBarItemIdentifierCardOptions+BlizzardHSAPIOptionType.h"
#import "NSScrubber+Private.h"

static NSTouchBarCustomizationIdentifier const NSTouchBarCustomizationIdentifierCardOptionsTouchBar = @"NSTouchBarCustomizationIdentifierCardOptionsTouchBar";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier = @"NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier";

@interface CardOptionsTouchBar () <NSTouchBarDelegate, NSScrubberDataSource, NSScrubberDelegate>
@property (weak) id<CardOptionsTouchBarDelegate> cardOptionsTouchBarDelegate;
@property (retain) NSArray<NSTouchBarItem *> *allPopoverItems;
@property (retain) NSArray<NSScrubber *> *allScrubbers;
@property (retain) NSMutableDictionary<NSString *, NSString *> *options;

@property (retain) NSPopoverTouchBarItem *optionTypeSetPopoverItem;
@property (retain) NSTouchBar *optionTypeSetTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeSetItem;
@property (retain) NSScrubber *optionTypeSetScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeClassPopoverItem;
@property (retain) NSTouchBar *optionTypeClassTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeClassItem;
@property (retain) NSScrubber *optionTypeClassScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeManaCostPopoverItem;
@property (retain) NSTouchBar *optionTypeManaCostTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeManaCostItem;
@property (retain) NSScrubber *optionTypeManaCostScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeAttackPopoverItem;
@property (retain) NSTouchBar *optionTypeAttackTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeAttackItem;
@property (retain) NSScrubber *optionTypeAttackScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeHealthPopoverItem;
@property (retain) NSTouchBar *optionTypeHealthTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeHealthItem;
@property (retain) NSScrubber *optionTypeHealthScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeCollectiblePopoverItem;
@property (retain) NSTouchBar *optionTypeCollectibleTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeCollectibleItem;
@property (retain) NSScrubber *optionTypeCollectibleScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeRarityPopoverItem;
@property (retain) NSTouchBar *optionTypeRarityTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeRarityItem;
@property (retain) NSScrubber *optionTypeRarityScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeTypePopoverItem;
@property (retain) NSTouchBar *optionTypeTypeTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeTypeItem;
@property (retain) NSScrubber *optionTypeTypeScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeMinionTypePopoverItem;
@property (retain) NSTouchBar *optionTypeMinionTypeTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeMinionTypeItem;
@property (retain) NSScrubber *optionTypeMinionTypeScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeSpellSchoolPopoverItem;
@property (retain) NSTouchBar *optionTypeSpellSchoolTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeSpellSchoolItem;
@property (retain) NSScrubber *optionTypeSpellSchoolScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeKeywordPopoverItem;
@property (retain) NSTouchBar *optionTypeKeywordTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeKeywordItem;
@property (retain) NSScrubber *optionTypeKeywordScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeGameModePopoverItem;
@property (retain) NSTouchBar *optionTypeGameModeTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeGameModeItem;
@property (retain) NSScrubber *optionTypeGameModeScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeSortPopoverItem;
@property (retain) NSTouchBar *optionTypeSortTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeSortItem;
@property (retain) NSScrubber *optionTypeSortScrubber;
@end

@implementation CardOptionsTouchBar

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSString *> *)options cardOptionsTouchBarDelegate:(id<CardOptionsTouchBarDelegate>)cardOptionsTouchBarDelegate {
    self = [self init];
    
    if (self) {
        NSMutableDictionary<NSString *, NSString *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        self.cardOptionsTouchBarDelegate = cardOptionsTouchBarDelegate;
        
        //
        
        [self configureTouchBarItems];
        [self setAttributes];
        [self updateItemsWithOptions:options];
    }
    
    return self;
}

- (void)dealloc {
    [_allPopoverItems release];
    [_allScrubbers release];
    [_options release];
    
    [_optionTypeSetPopoverItem release];
    [_optionTypeSetTouchBar release];
    [_optionTypeSetItem release];
    [_optionTypeSetScrubber release];
    
    [_optionTypeClassPopoverItem release];
    [_optionTypeClassTouchBar release];
    [_optionTypeClassItem release];
    [_optionTypeClassScrubber release];
    
    [_optionTypeManaCostPopoverItem release];
    [_optionTypeManaCostTouchBar release];
    [_optionTypeManaCostItem release];
    [_optionTypeManaCostScrubber release];
    
    [_optionTypeAttackPopoverItem release];
    [_optionTypeAttackTouchBar release];
    [_optionTypeAttackItem release];
    [_optionTypeAttackScrubber release];
    
    [_optionTypeHealthPopoverItem release];
    [_optionTypeHealthTouchBar release];
    [_optionTypeHealthItem release];
    [_optionTypeHealthScrubber release];
    
    [_optionTypeCollectiblePopoverItem release];
    [_optionTypeCollectibleTouchBar release];
    [_optionTypeCollectibleItem release];
    [_optionTypeCollectibleScrubber release];
    
    [_optionTypeRarityPopoverItem release];
    [_optionTypeRarityTouchBar release];
    [_optionTypeRarityItem release];
    [_optionTypeRarityScrubber release];
    
    [_optionTypeTypePopoverItem release];
    [_optionTypeTypeTouchBar release];
    [_optionTypeTypeItem release];
    [_optionTypeTypeScrubber release];
    
    [_optionTypeMinionTypePopoverItem release];
    [_optionTypeMinionTypeTouchBar release];
    [_optionTypeMinionTypeItem release];
    [_optionTypeMinionTypeScrubber release];
    
    [_optionTypeSpellSchoolPopoverItem release];
    [_optionTypeSpellSchoolTouchBar release];
    [_optionTypeSpellSchoolItem release];
    [_optionTypeSpellSchoolScrubber release];
    
    [_optionTypeKeywordPopoverItem release];
    [_optionTypeKeywordTouchBar release];
    [_optionTypeKeywordItem release];
    [_optionTypeKeywordScrubber release];
    
    [_optionTypeGameModePopoverItem release];
    [_optionTypeGameModeTouchBar release];
    [_optionTypeGameModeItem release];
    [_optionTypeGameModeScrubber release];
    
    [_optionTypeSortPopoverItem release];
    [_optionTypeSortTouchBar release];
    [_optionTypeSortItem release];
    [_optionTypeSortScrubber release];
    
    [super dealloc];
}

- (void)setAttributes {
    self.delegate = self;
    self.customizationIdentifier = NSTouchBarCustomizationIdentifierCardOptionsTouchBar;
    self.defaultItemIdentifiers = AllNSTouchBarItemIdentifierCardOptions();
    self.customizationAllowedItemIdentifiers = AllNSTouchBarItemIdentifierCardOptions();
}

- (void)configureTouchBarItems {
    NSPopoverTouchBarItem *optionTypeSetPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeSet];
    NSTouchBar *optionTypeSetTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeSetItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeSet];
    NSScrubber *optionTypeSetScrubber = [NSScrubber new];
    self.optionTypeSetPopoverItem = optionTypeSetPopoverItem;
    self.optionTypeSetTouchBar = optionTypeSetTouchBar;
    self.optionTypeSetItem = optionTypeSetItem;
    self.optionTypeSetScrubber = optionTypeSetScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeSetPopoverItem
                          touchBar:optionTypeSetTouchBar
                        customItem:optionTypeSetItem
                          scrubber:optionTypeSetScrubber
                             title:NSLocalizedString(@"CARD_SET", @"")
                          itemSize:CGSizeMake(230.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *optionTypeClassPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeClass];
    NSTouchBar *optionTypeClassTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeClassItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeClass];
    NSScrubber *optionTypeClassScrubber = [NSScrubber new];
    self.optionTypeClassPopoverItem = optionTypeClassPopoverItem;
    self.optionTypeClassTouchBar = optionTypeClassTouchBar;
    self.optionTypeClassItem = optionTypeClassItem;
    self.optionTypeClassScrubber = optionTypeClassScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeClassPopoverItem
                          touchBar:optionTypeClassTouchBar
                        customItem:optionTypeClassItem
                          scrubber:optionTypeClassScrubber
                             title:NSLocalizedString(@"CARD_CLASS", @"")
                          itemSize:CGSizeMake(150.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *optionTypeManaCostPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeManaCost];
    NSTouchBar *optionTypeManaCostTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeManaCostItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeManaCost];
    NSScrubber *optionTypeManaCostScrubber = [NSScrubber new];
    self.optionTypeManaCostPopoverItem = optionTypeManaCostPopoverItem;
    self.optionTypeManaCostTouchBar = optionTypeManaCostTouchBar;
    self.optionTypeManaCostItem = optionTypeManaCostItem;
    self.optionTypeManaCostScrubber = optionTypeManaCostScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeManaCostPopoverItem
                          touchBar:optionTypeManaCostTouchBar
                        customItem:optionTypeManaCostItem
                          scrubber:optionTypeManaCostScrubber
                             title:NSLocalizedString(@"CARD_MANA_COST", @"")
                          itemSize:CGSizeMake(50.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *optionTypeAttackPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeAttack];
    NSTouchBar *optionTypeAttackTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeAttackItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeAttack];
    NSScrubber *optionTypeAttackScrubber = [NSScrubber new];
    self.optionTypeAttackPopoverItem = optionTypeAttackPopoverItem;
    self.optionTypeAttackTouchBar = optionTypeAttackTouchBar;
    self.optionTypeAttackItem = optionTypeAttackItem;
    self.optionTypeAttackScrubber = optionTypeAttackScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeAttackPopoverItem
                          touchBar:optionTypeAttackTouchBar
                        customItem:optionTypeAttackItem
                          scrubber:optionTypeAttackScrubber
                             title:NSLocalizedString(@"CARD_ATTACK", @"")
                          itemSize:CGSizeMake(50.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *optionTypeHealthPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeHealth];
    NSTouchBar *optionTypeHealthTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeHealthItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeHealth];
    NSScrubber *optionTypeHealthScrubber = [NSScrubber new];
    self.optionTypeHealthPopoverItem = optionTypeHealthPopoverItem;
    self.optionTypeHealthTouchBar = optionTypeHealthTouchBar;
    self.optionTypeHealthItem = optionTypeHealthItem;
    self.optionTypeHealthScrubber = optionTypeHealthScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeHealthPopoverItem
                          touchBar:optionTypeHealthTouchBar
                        customItem:optionTypeHealthItem
                          scrubber:optionTypeHealthScrubber
                             title:NSLocalizedString(@"CARD_HEALTH", @"")
                          itemSize:CGSizeMake(50.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *optionTypeCollectiblePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeCollecticle];
    NSTouchBar *optionTypeCollectibleTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeCollectibleItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeCollecticle];
    NSScrubber *optionTypeCollectibleScrubber = [NSScrubber new];
    self.optionTypeCollectiblePopoverItem = optionTypeCollectiblePopoverItem;
    self.optionTypeCollectibleTouchBar = optionTypeCollectibleTouchBar;
    self.optionTypeCollectibleItem = optionTypeCollectibleItem;
    self.optionTypeCollectibleScrubber = optionTypeCollectibleScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeCollectiblePopoverItem
                          touchBar:optionTypeCollectibleTouchBar
                        customItem:optionTypeCollectibleItem
                          scrubber:optionTypeCollectibleScrubber
                             title:NSLocalizedString(@"CARD_COLLECTIBLE", @"")
                          itemSize:CGSizeMake(150.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *optionTypeRarityPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeRarity];
    NSTouchBar *optionTypeRarityTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeRarityItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeRarity];
    NSScrubber *optionTypeRarityScrubber = [NSScrubber new];
    self.optionTypeRarityPopoverItem = optionTypeRarityPopoverItem;
    self.optionTypeRarityTouchBar = optionTypeRarityTouchBar;
    self.optionTypeRarityItem = optionTypeRarityItem;
    self.optionTypeRarityScrubber = optionTypeRarityScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeRarityPopoverItem
                          touchBar:optionTypeRarityTouchBar
                        customItem:optionTypeRarityItem
                          scrubber:optionTypeRarityScrubber
                             title:NSLocalizedString(@"CARD_RARITY", @"")
                          itemSize:CGSizeMake(150.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *optionTypeTypePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeType];
    NSTouchBar *optionTypeTypeTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeTypeItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeType];
    NSScrubber *optionTypeTypeScrubber = [NSScrubber new];
    self.optionTypeTypePopoverItem = optionTypeTypePopoverItem;
    self.optionTypeTypeTouchBar = optionTypeTypeTouchBar;
    self.optionTypeTypeItem = optionTypeTypeItem;
    self.optionTypeTypeScrubber = optionTypeTypeScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeTypePopoverItem
                          touchBar:optionTypeTypeTouchBar
                        customItem:optionTypeTypeItem
                          scrubber:optionTypeTypeScrubber
                             title:NSLocalizedString(@"CARD_TYPE", @"")
                          itemSize:CGSizeMake(150.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *optionTypeMinionTypePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeMinionType];
    NSTouchBar *optionTypeMinionTypeTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeMinionTypeItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeMinionType];
    NSScrubber *optionTypeMinionTypeScrubber = [NSScrubber new];
    self.optionTypeMinionTypePopoverItem = optionTypeMinionTypePopoverItem;
    self.optionTypeMinionTypeTouchBar = optionTypeMinionTypeTouchBar;
    self.optionTypeMinionTypeItem = optionTypeMinionTypeItem;
    self.optionTypeMinionTypeScrubber = optionTypeMinionTypeScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeMinionTypePopoverItem
                          touchBar:optionTypeMinionTypeTouchBar
                        customItem:optionTypeMinionTypeItem
                          scrubber:optionTypeMinionTypeScrubber
                             title:NSLocalizedString(@"CARD_MINION_TYPE", @"")
                          itemSize:CGSizeMake(150.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *optionTypeSpellSchoolPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeSchoolSpell];
    NSTouchBar *optionTypeSpellSchoolTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeSpellSchoolItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeSchoolSpell];
    NSScrubber *optionTypeSpellSchoolScrubber = [NSScrubber new];
    self.optionTypeSpellSchoolPopoverItem = optionTypeSpellSchoolPopoverItem;
    self.optionTypeSpellSchoolTouchBar = optionTypeSpellSchoolTouchBar;
    self.optionTypeSpellSchoolItem = optionTypeSpellSchoolItem;
    self.optionTypeSpellSchoolScrubber = optionTypeSpellSchoolScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeSpellSchoolPopoverItem
                          touchBar:optionTypeSpellSchoolTouchBar
                        customItem:optionTypeSpellSchoolItem
                          scrubber:optionTypeSpellSchoolScrubber
                             title:NSLocalizedString(@"CARD_SPELL_SCHOOL", @"")
                          itemSize:CGSizeMake(150.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *optionTypeKeywordPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeKeyword];
    NSTouchBar *optionTypeKeywordTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeKeywordItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeKeyword];
    NSScrubber *optionTypeKeywordScrubber = [NSScrubber new];
    self.optionTypeKeywordPopoverItem = optionTypeKeywordPopoverItem;
    self.optionTypeKeywordTouchBar = optionTypeKeywordTouchBar;
    self.optionTypeKeywordItem = optionTypeKeywordItem;
    self.optionTypeKeywordScrubber = optionTypeKeywordScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeKeywordPopoverItem
                          touchBar:optionTypeKeywordTouchBar
                        customItem:optionTypeKeywordItem
                          scrubber:optionTypeKeywordScrubber
                             title:NSLocalizedString(@"CARD_KEYWORD", @"")
                          itemSize:CGSizeMake(180.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *optionTypeGameModePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeGameMode];
    NSTouchBar *optionTypeGameModeTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeGameModeItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeGameMode];
    NSScrubber *optionTypeGameModeScrubber = [NSScrubber new];
    self.optionTypeGameModePopoverItem = optionTypeGameModePopoverItem;
    self.optionTypeGameModeTouchBar = optionTypeGameModeTouchBar;
    self.optionTypeGameModeItem = optionTypeGameModeItem;
    self.optionTypeGameModeScrubber = optionTypeGameModeScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeGameModePopoverItem
                          touchBar:optionTypeGameModeTouchBar
                        customItem:optionTypeGameModeItem
                          scrubber:optionTypeGameModeScrubber
                             title:NSLocalizedString(@"CARD_GAME_MODE", @"")
                          itemSize:CGSizeMake(180.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *optionTypeSortPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeSort];
    NSTouchBar *optionTypeSortTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeSortItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeSort];
    NSScrubber *optionTypeSortScrubber = [NSScrubber new];
    self.optionTypeSortPopoverItem = optionTypeSortPopoverItem;
    self.optionTypeSortTouchBar = optionTypeSortTouchBar;
    self.optionTypeSortItem = optionTypeSortItem;
    self.optionTypeSortScrubber = optionTypeSortScrubber;
    
    [self wireItemsWithPopoverItem:optionTypeSortPopoverItem
                          touchBar:optionTypeSortTouchBar
                        customItem:optionTypeSortItem
                          scrubber:optionTypeSortScrubber
                             title:NSLocalizedString(@"CARD_SORT", @"")
                          itemSize:CGSizeMake(200.0f, 30.0f)];
    
    //
    
    self.allPopoverItems = @[
        optionTypeSetPopoverItem,
        optionTypeClassPopoverItem,
        optionTypeManaCostPopoverItem,
        optionTypeAttackPopoverItem,
        optionTypeHealthPopoverItem,
        optionTypeCollectiblePopoverItem,
        optionTypeRarityPopoverItem,
        optionTypeTypePopoverItem,
        optionTypeMinionTypePopoverItem,
        optionTypeSpellSchoolPopoverItem,
        optionTypeKeywordPopoverItem,
        optionTypeGameModePopoverItem,
        optionTypeSortPopoverItem
    ];
    
    self.allScrubbers = @[
        optionTypeSetScrubber,
        optionTypeClassScrubber,
        optionTypeManaCostScrubber,
        optionTypeAttackScrubber,
        optionTypeHealthScrubber,
        optionTypeCollectibleScrubber,
        optionTypeRarityScrubber,
        optionTypeTypeScrubber,
        optionTypeMinionTypeScrubber,
        optionTypeSpellSchoolScrubber,
        optionTypeKeywordScrubber,
        optionTypeGameModeScrubber,
        optionTypeSortScrubber
    ];
    
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

- (void)updateItemsWithOptions:(NSDictionary<NSString *,NSString *> *)options {
    if ([options isEqualToDictionary:self.options]) return;
    
    NSMutableDictionary<NSString *, NSString *> *mutableOptions = [options mutableCopy];
    self.options = mutableOptions;
    [mutableOptions release];
    
    //
    
    [self.allScrubbers enumerateObjectsUsingBlock:^(NSScrubber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self hasEmptyRowAtScrubber:obj]) {
            NSArray<NSString *> *keys = [self sortedKeysFromScrubber:obj];
            NSUInteger index = [keys indexOfString:@""];
            
            if ([obj respondsToSelector:@selector(_interactiveSelectItemAtIndex:animated:)]) {
                // this will excute `scrubber:didSelectItemAtIndex:`
                [obj _interactiveSelectItemAtIndex:index animated:YES];
            }
        }
    }];
    
    //
    
    [options enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj1, BOOL * _Nonnull stop) {
        NSScrubber * _Nullable scrubber = [self scrubberFromOptionType:key];
        
        if (scrubber != nil) {
            NSArray<NSString *> *keys = [self sortedKeysFromScrubber:scrubber];
            NSInteger __block index = -1;
            
            [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj2 isEqualToString:obj1]) {
                    index = idx;
                    *stop = YES;
                }
            }];
            
            if (index == -1) return;
            
            if ([scrubber respondsToSelector:@selector(_interactiveSelectItemAtIndex:animated:)]) {
                // this will excute `scrubber:didSelectItemAtIndex:`
                [scrubber _interactiveSelectItemAtIndex:index animated:YES];
            }
            [scrubber scrollItemAtIndex:index toAlignment:NSScrubberAlignmentCenter];
        }
    }];
}

- (void)wireItemsWithPopoverItem:(NSPopoverTouchBarItem *)popoverItem
                        touchBar:(NSTouchBar *)touchBar
                      customItem:(NSCustomTouchBarItem *)customItem
                        scrubber:(NSScrubber *)scrubber
                           title:(NSString *)title
                        itemSize:(CGSize)itemSize {
    
    popoverItem.collapsedRepresentationImage = [NSImage imageWithSystemSymbolName:PrefferedSystemSymbolFromBlizzardHSAPIDefaultOptions([self optionTypeFromScrubber:scrubber]) accessibilityDescription:nil];
    popoverItem.customizationLabel = title;
    popoverItem.collapsedRepresentationLabel = title;
    popoverItem.popoverTouchBar = touchBar;
    popoverItem.pressAndHoldTouchBar = touchBar;
    touchBar.delegate = self;
    touchBar.defaultItemIdentifiers = @[popoverItem.identifier];
    
    customItem.view = scrubber;
    scrubber.backgroundColor = NSColor.darkGrayColor;
    scrubber.mode = NSScrubberModeFree;
    scrubber.selectionOverlayStyle = [NSScrubberSelectionStyle outlineOverlayStyle];
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

- (NSScrubber * _Nullable)scrubberFromOptionType:(BlizzardHSAPIOptionType)optionType {
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return self.optionTypeSetScrubber;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return self.optionTypeClassScrubber;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return self.optionTypeManaCostScrubber;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return self.optionTypeAttackScrubber;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return self.optionTypeHealthScrubber;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return self.optionTypeCollectibleScrubber;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return self.optionTypeTypeScrubber;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return self.optionTypeMinionTypeScrubber;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return self.optionTypeSpellSchoolScrubber;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return self.optionTypeKeywordScrubber;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return self.optionTypeGameModeScrubber;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return self.optionTypeSortScrubber;
    } else {
        return nil;
    }
}

- (BlizzardHSAPIOptionType _Nullable)optionTypeFromScrubber:(NSScrubber *)scrubber {
    BlizzardHSAPIOptionType _Nullable optionType = nil;
    
    if ([scrubber isEqual:self.optionTypeSetScrubber]) {
        optionType = BlizzardHSAPIOptionTypeSet;
    } else if ([scrubber isEqual:self.optionTypeClassScrubber]) {
        optionType = BlizzardHSAPIOptionTypeClass;
    } else if ([scrubber isEqual:self.optionTypeManaCostScrubber]) {
        optionType = BlizzardHSAPIOptionTypeManaCost;
    } else if ([scrubber isEqual:self.optionTypeAttackScrubber]) {
        optionType = BlizzardHSAPIOptionTypeAttack;
    } else if ([scrubber isEqual:self.optionTypeHealthScrubber]) {
        optionType = BlizzardHSAPIOptionTypeHealth;
    } else if ([scrubber isEqual:self.optionTypeCollectibleScrubber]) {
        optionType = BlizzardHSAPIOptionTypeCollectible;
    } else if ([scrubber isEqual:self.optionTypeRarityScrubber]) {
        optionType = BlizzardHSAPIOptionTypeRarity;
    } else if ([scrubber isEqual:self.optionTypeTypeScrubber]) {
        optionType = BlizzardHSAPIOptionTypeType;
    } else if ([scrubber isEqual:self.optionTypeMinionTypeScrubber]) {
        optionType = BlizzardHSAPIOptionTypeMinionType;
    } else if ([scrubber isEqual:self.optionTypeSpellSchoolScrubber]) {
        optionType = BlizzardHSAPIOptionTypeSpellSchool;
    } else if ([scrubber isEqual:self.optionTypeKeywordScrubber]) {
        optionType = BlizzardHSAPIOptionTypeKeyword;
    } else if ([scrubber isEqual:self.optionTypeGameModeScrubber]) {
        optionType = BlizzardHSAPIOptionTypeGameMode;
    } else if ([scrubber isEqual:self.optionTypeSortScrubber]) {
        optionType = BlizzardHSAPIOptionTypeSort;
    }
    
    return optionType;
}

- (BOOL)hasEmptyRowAtScrubber:(NSScrubber *)scrubber {
    if ([scrubber isEqual:self.optionTypeSetScrubber]) {
        return YES;
    } else if ([scrubber isEqual:self.optionTypeClassScrubber]) {
        return YES;
    } else if ([scrubber isEqual:self.optionTypeManaCostScrubber]) {
        return YES;
    } else if ([scrubber isEqual:self.optionTypeAttackScrubber]) {
        return YES;
    } else if ([scrubber isEqual:self.optionTypeHealthScrubber]) {
        return YES;
    } else if ([scrubber isEqual:self.optionTypeCollectibleScrubber]) {
        return NO;
    } else if ([scrubber isEqual:self.optionTypeRarityScrubber]) {
        return YES;
    } else if ([scrubber isEqual:self.optionTypeTypeScrubber]) {
        return YES;
    } else if ([scrubber isEqual:self.optionTypeMinionTypeScrubber]) {
        return YES;
    } else if ([scrubber isEqual:self.optionTypeSpellSchoolScrubber]) {
        return YES;
    } else if ([scrubber isEqual:self.optionTypeKeywordScrubber]) {
        return YES;
    } else if ([scrubber isEqual:self.optionTypeSortScrubber]) {
        return NO;
    } else {
        return NO;
    }
}

- (NSDictionary<NSString *, NSString *> * _Nullable)dicFromScrubber:(NSScrubber *)scrubber {
    NSMutableDictionary<NSString *, NSString *> * _Nullable mutableDic = nil;
    NSArray<NSString *> * _Nullable filterKeys = nil;
    
    if ([scrubber isEqual:self.optionTypeSetScrubber]) {
        mutableDic = [hsCardSetsWithLocalizable() mutableCopy];
        filterKeys = nil;
    } else if ([scrubber isEqual:self.optionTypeClassScrubber]) {
        mutableDic = [hsCardClassesWithLocalizable() mutableCopy];
        filterKeys = @[NSStringFromHSCardClass(HSCardClassDeathKnight)];
    } else if ([scrubber isEqual:self.optionTypeManaCostScrubber] || [scrubber isEqual:self.optionTypeAttackScrubber] || [scrubber isEqual:self.optionTypeHealthScrubber]) {
        mutableDic = [@{@"1": @"1",
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
    } else if ([scrubber isEqual:self.optionTypeCollectibleScrubber]) {
        mutableDic = [hsCardCollectiblesWithLocalizable() mutableCopy];
        filterKeys = nil;
    } else if ([scrubber isEqual:self.optionTypeRarityScrubber]) {
        mutableDic = [hsCardRaritiesWithLocalizable() mutableCopy];
        filterKeys = @[NSStringFromHSCardRarity(HSCardRarityNull)];
    } else if ([scrubber isEqual:self.optionTypeTypeScrubber]) {
        mutableDic = [hsCardTypesWithLocalizable() mutableCopy];
        filterKeys = nil;
    } else if ([scrubber isEqual:self.optionTypeMinionTypeScrubber]) {
        mutableDic = [hsCardMinionTypesWithLocalizable() mutableCopy];
        filterKeys = nil;
    } else if ([scrubber isEqual:self.optionTypeSpellSchoolScrubber]) {
        mutableDic = [hsCardSpellSchoolsWithLocalizable() mutableCopy];
        filterKeys = nil;
    } else if ([scrubber isEqual:self.optionTypeKeywordScrubber]) {
        mutableDic = [hsCardKeywordsWithLocalizable() mutableCopy];
        filterKeys = nil;
    } else if ([scrubber isEqual:self.optionTypeGameModeScrubber]) {
        mutableDic = [hsCardGameModesWithLocalizable() mutableCopy];
        filterKeys = nil;
    } else if ([scrubber isEqual:self.optionTypeSortScrubber]) {
        mutableDic = [hsCardSortsWithLocalizable() mutableCopy];
        filterKeys = nil;
    }
    
    //
    
    if ([self hasEmptyRowAtScrubber:scrubber]) {
        mutableDic[@""] = NSLocalizedString(@"ALL", @"");
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

- (NSArray<NSString *> *)sortedKeysFromScrubber:(NSScrubber *)scrubber {
    NSDictionary<NSString *, NSString *> * _Nullable dic = [self dicFromScrubber:scrubber];
    NSUInteger (^__block converter)(NSString *);
    BOOL ascending = YES;
    
    if ([scrubber isEqual:self.optionTypeSetScrubber]) {
        converter = ^NSUInteger(NSString * key) {
            return HSCardSetFromNSString(key);
        };
        ascending = NO;
    } else if ([scrubber isEqual:self.optionTypeClassScrubber]) {
        converter = ^NSUInteger(NSString * key) {
            return HSCardClassFromNSString(key);
        };
        ascending = YES;
    } else if ([scrubber isEqual:self.optionTypeManaCostScrubber] || [scrubber isEqual:self.optionTypeAttackScrubber] || [scrubber isEqual:self.optionTypeHealthScrubber]) {
        converter = ^NSUInteger(NSString *key) {
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSUInteger value = [formatter numberFromString:key].unsignedIntegerValue;
            [formatter release];
            return value;
        };
        ascending = YES;
    } else if ([scrubber isEqual:self.optionTypeCollectibleScrubber]) {
        converter = ^NSUInteger(NSString * key) {
            return HSCardCollectibleFromNSString(key);
        };
        ascending = YES;
    } else if ([scrubber isEqual:self.optionTypeRarityScrubber]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardRarityFromNSString(key);
        };
        ascending = YES;
    } else if ([scrubber isEqual:self.optionTypeTypeScrubber]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardTypeFromNSString(key);
        };
        ascending = YES;
    } else if ([scrubber isEqual:self.optionTypeMinionTypeScrubber]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardMinionTypeFromNSString(key);
        };
        ascending = YES;
    } else if ([scrubber isEqual:self.optionTypeSpellSchoolScrubber]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardSpellSchoolFromNSString(key);
        };
        ascending = YES;
    } else if ([scrubber isEqual:self.optionTypeKeywordScrubber]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardKeywordFromNSString(key);
        };
        ascending = YES;
    } else if ([scrubber isEqual:self.optionTypeGameModeScrubber]) {
        converter = ^NSUInteger(NSString *key) {
            return HSCardGameModeFromNSString(key);
        };
        ascending = YES;
    } else if ([scrubber isEqual:self.optionTypeSortScrubber]) {
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
        
        [self.allPopoverItems enumerateObjectsUsingBlock:^(NSTouchBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([identifier isEqualToString:obj.identifier]) {
                result = obj;
                *stop = YES;
            }
        }];
        
        return result;
    } else if ([touchBar isEqual:self.optionTypeSetTouchBar]) {
        return self.optionTypeSetItem;
    } else if ([touchBar isEqual:self.optionTypeClassTouchBar]) {
        return self.optionTypeClassItem;
    } else if ([touchBar isEqual:self.optionTypeManaCostTouchBar]) {
        return self.optionTypeManaCostItem;
    } else if ([touchBar isEqual:self.optionTypeAttackTouchBar]) {
        return self.optionTypeAttackItem;
    } else if ([touchBar isEqual:self.optionTypeHealthTouchBar]) {
        return self.optionTypeHealthItem;
    } else if ([touchBar isEqual:self.optionTypeCollectibleTouchBar]) {
        return self.optionTypeCollectibleItem;
    } else if ([touchBar isEqual:self.optionTypeRarityTouchBar]) {
        return self.optionTypeRarityItem;
    } else if ([touchBar isEqual:self.optionTypeTypeTouchBar]) {
        return self.optionTypeTypeItem;
    } else if ([touchBar isEqual:self.optionTypeMinionTypeTouchBar]) {
        return self.optionTypeMinionTypeItem;
    } else if ([touchBar isEqual:self.optionTypeSpellSchoolTouchBar]) {
        return self.optionTypeSpellSchoolItem;
    } else if ([touchBar isEqual:self.optionTypeKeywordTouchBar]) {
        return self.optionTypeKeywordItem;
    } else if ([touchBar isEqual:self.optionTypeGameModeTouchBar]) {
        return self.optionTypeGameModeItem;
    } else if ([touchBar isEqual:self.optionTypeSortTouchBar]) {
        return self.optionTypeSortItem;
    } else {
        return nil;
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
    
    NSString * _Nullable key = keys[index];
    NSString * _Nullable title = nil;
    
    if (key != nil) {
        title = dic[key];
    }
    
    if (title != nil) {
        item.title = dic[keys[index]];
    }
    
    return item;
}

#pragma mark - NSScrubberDelegate

- (void)scrubber:(NSScrubber *)scrubber didSelectItemAtIndex:(NSInteger)selectedIndex {
    NSArray<NSString *> *keys = [self sortedKeysFromScrubber:scrubber];
    BlizzardHSAPIOptionType optionType = [self optionTypeFromScrubber:scrubber];
    NSString *newValue = keys[selectedIndex];
    
    if (newValue == nil) {
        self.options[optionType] = nil;
    } else if ([newValue isEqualToString:@""]) {
        self.options[optionType] = nil;
    } else if ((newValue == nil) && (self.options[optionType] == nil)) {
        return;
    } else if ([newValue isEqualToString:self.options[optionType]]) {
        return;
    } else {
        self.options[optionType] = keys[selectedIndex];
    }
    
    [self.cardOptionsTouchBarDelegate cardOptionsTouchBar:self changedOption:self.options];
}

@end
