//
//  DeckAddOptionsTouchBar.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "DeckAddCardOptionsTouchBar.h"
#import "NSTouchBarItemIdentifierDeckAddCardOptionType+BlizzardHSAPIOptionType.h"
#import "NSScrubber+Private.h"
#import "DeckAddCardOptionsMenuFactory.h"
#import <StoneNamuResources/StoneNamuResources.h>

static NSTouchBarCustomizationIdentifier const NSTouchBarCustomizationIdentifierDeckAddCardOptionsTouchBar = @"NSTouchBarCustomizationIdentifierDeckAddCardOptionsTouchBar";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier = @"NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier";

@interface DeckAddCardOptionsTouchBar () <NSTouchBarDelegate, NSScrubberDataSource, NSScrubberDelegate>
@property (assign) id<DeckAddCardOptionsTouchBarDelegate> deckAddCardOptionsTouchBarDelegate;
@property (retain) DeckAddCardOptionsMenuFactory *factory;

@property (retain) NSMutableDictionary<NSString *, NSSet<NSString *> *> *options;

@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSPopoverTouchBarItem *> *allPopoverItems;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSTouchBar *> *allTouchBars;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSCustomTouchBarItem *> *allCustomTouchBarItems;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSScrubber *> *allScrubbers;
@end

@implementation DeckAddCardOptionsTouchBar

- (instancetype)initWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options localDeck:(LocalDeck * _Nullable)localDeck deckAddCardOptionsTouchBarDelegate:(id<DeckAddCardOptionsTouchBarDelegate>)deckAddCardOptionsTouchBarDelegate {
    self = [self init];
    
    if (self) {
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        DeckAddCardOptionsMenuFactory *factory = [[DeckAddCardOptionsMenuFactory alloc] initWithLocalDeck:localDeck];
        self.factory = factory;
        [factory release];
        
        self.deckAddCardOptionsTouchBarDelegate = deckAddCardOptionsTouchBarDelegate;
        
        [self configureTouchBarItems];
        [self setAttributes];
        [self updateItemsWithOptions:options];
        [self bind];
        [self.factory updateItems];
    }
    
    return self;
}

- (void)dealloc {
    [_factory release];
    
    [_options release];
    [_allPopoverItems release];
    [_allTouchBars release];
    [_allCustomTouchBarItems release];
    [_allScrubbers release];
    [super dealloc];
}

- (void)setAttributes {
    self.delegate = self;
    self.customizationIdentifier = NSTouchBarCustomizationIdentifierDeckAddCardOptionsTouchBar;
    self.defaultItemIdentifiers = allNSTouchBarItemIdentifierDeckAddCardOptionTypes();
    self.customizationAllowedItemIdentifiers = allNSTouchBarItemIdentifierDeckAddCardOptionTypes();
}

- (void)configureTouchBarItems {
    NSPopoverTouchBarItem *optionTypeSetPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeSet];
    NSTouchBar *optionTypeSetTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeSetItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeSet];
    NSScrubber *optionTypeSetScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeSetPopoverItem
                          touchBar:optionTypeSetTouchBar
                        customItem:optionTypeSetItem
                          scrubber:optionTypeSetScrubber
                          itemSize:CGSizeMake(230.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeSet];
    
    //
    
    NSPopoverTouchBarItem *optionTypeClassPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeClass];
    NSTouchBar *optionTypeClassTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeClassItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeClass];
    NSScrubber *optionTypeClassScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeClassPopoverItem
                          touchBar:optionTypeClassTouchBar
                        customItem:optionTypeClassItem
                          scrubber:optionTypeClassScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeClass];
    
    //
    
    NSPopoverTouchBarItem *optionTypeManaCostPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeManaCost];
    NSTouchBar *optionTypeManaCostTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeManaCostItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeManaCost];
    NSScrubber *optionTypeManaCostScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeManaCostPopoverItem
                          touchBar:optionTypeManaCostTouchBar
                        customItem:optionTypeManaCostItem
                          scrubber:optionTypeManaCostScrubber
                          itemSize:CGSizeMake(50.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeManaCost];
    
    //
    
    NSPopoverTouchBarItem *optionTypeAttackPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeAttack];
    NSTouchBar *optionTypeAttackTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeAttackItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeAttack];
    NSScrubber *optionTypeAttackScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeAttackPopoverItem
                          touchBar:optionTypeAttackTouchBar
                        customItem:optionTypeAttackItem
                          scrubber:optionTypeAttackScrubber
                          itemSize:CGSizeMake(50.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeAttack];
    
    //
    
    NSPopoverTouchBarItem *optionTypeHealthPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeHealth];
    NSTouchBar *optionTypeHealthTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeHealthItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeHealth];
    NSScrubber *optionTypeHealthScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeHealthPopoverItem
                          touchBar:optionTypeHealthTouchBar
                        customItem:optionTypeHealthItem
                          scrubber:optionTypeHealthScrubber
                          itemSize:CGSizeMake(50.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeHealth];
    
    //
    
    NSPopoverTouchBarItem *optionTypeCollectiblePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeCollecticle];
    NSTouchBar *optionTypeCollectibleTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeCollectibleItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeCollecticle];
    NSScrubber *optionTypeCollectibleScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeCollectiblePopoverItem
                          touchBar:optionTypeCollectibleTouchBar
                        customItem:optionTypeCollectibleItem
                          scrubber:optionTypeCollectibleScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeCollectible];
    
    //
    
    NSPopoverTouchBarItem *optionTypeRarityPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeRarity];
    NSTouchBar *optionTypeRarityTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeRarityItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeRarity];
    NSScrubber *optionTypeRarityScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeRarityPopoverItem
                          touchBar:optionTypeRarityTouchBar
                        customItem:optionTypeRarityItem
                          scrubber:optionTypeRarityScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeRarity];
    
    //
    
    NSPopoverTouchBarItem *optionTypeTypePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeType];
    NSTouchBar *optionTypeTypeTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeTypeItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeType];
    NSScrubber *optionTypeTypeScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeTypePopoverItem
                          touchBar:optionTypeTypeTouchBar
                        customItem:optionTypeTypeItem
                          scrubber:optionTypeTypeScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeType];
    
    //
    
    NSPopoverTouchBarItem *optionTypeMinionTypePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeMinionType];
    NSTouchBar *optionTypeMinionTypeTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeMinionTypeItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeMinionType];
    NSScrubber *optionTypeMinionTypeScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeMinionTypePopoverItem
                          touchBar:optionTypeMinionTypeTouchBar
                        customItem:optionTypeMinionTypeItem
                          scrubber:optionTypeMinionTypeScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeMinionType];
    
    //
    
    NSPopoverTouchBarItem *optionTypeSpellSchoolPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeSchoolSpell];
    NSTouchBar *optionTypeSpellSchoolTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeSpellSchoolItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeSchoolSpell];
    NSScrubber *optionTypeSpellSchoolScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeSpellSchoolPopoverItem
                          touchBar:optionTypeSpellSchoolTouchBar
                        customItem:optionTypeSpellSchoolItem
                          scrubber:optionTypeSpellSchoolScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeSpellSchool];
    
    //
    
    NSPopoverTouchBarItem *optionTypeKeywordPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeKeyword];
    NSTouchBar *optionTypeKeywordTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeKeywordItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeKeyword];
    NSScrubber *optionTypeKeywordScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeKeywordPopoverItem
                          touchBar:optionTypeKeywordTouchBar
                        customItem:optionTypeKeywordItem
                          scrubber:optionTypeKeywordScrubber
                          itemSize:CGSizeMake(180.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeKeyword];
    
    //
    
    NSPopoverTouchBarItem *optionTypeGameModePopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeGameMode];
    NSTouchBar *optionTypeGameModeTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeGameModeItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeGameMode];
    NSScrubber *optionTypeGameModeScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:optionTypeGameModePopoverItem
                          touchBar:optionTypeGameModeTouchBar
                        customItem:optionTypeGameModeItem
                          scrubber:optionTypeGameModeScrubber
                          itemSize:CGSizeMake(180.0f, 30.0f)
                        optionType:BlizzardHSAPIOptionTypeGameMode];
    
    //
    
    NSPopoverTouchBarItem *optionTypeSortPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeSort];
    NSTouchBar *optionTypeSortTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *optionTypeSortItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDeckAddCardOptionTypeSort];
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
        obj.collapsedRepresentationImage = [self.factory imageForCardOptionTypeWithValues:options[key] optionType:key];
    }];
    
    [self.allScrubbers enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType _Nonnull key, NSScrubber * _Nonnull obj, BOOL * _Nonnull stop) {
        
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
            
            if (oldIndex != newIndex) {
                [obj scrollItemAtIndex:newIndex toAlignment:NSScrubberAlignmentCenter animated:YES];
                [obj setSelectedIndex:newIndex animated:YES];
            }
        }
    }];
}

- (void)setLocalDeck:(LocalDeck *)localDeck {
    [self.factory setLocalDeck:localDeck];
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
                                               name:NSNotificationNameDeckAddCardOptionsMenuFactoryShouldUpdateItems
                                             object:self.factory];
}

- (void)shouldUpdateReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.allPopoverItems enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType _Nonnull key, NSPopoverTouchBarItem * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.collapsedRepresentationLabel = [self.factory titleForOptionType:key];
            obj.customizationLabel = [self.factory titleForOptionType:key];
        }];
        
        [self.allScrubbers.allValues enumerateObjectsUsingBlock:^(NSScrubber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj reloadData];
        }];
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
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
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
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
        filterKeys = nil;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        mutableDic = [self.factory.slugsAndNames[optionType] mutableCopy];
        filterKeys = nil;
    }
    
    //
    
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
}

- (NSArray<NSString *> * _Nullable)sortedKeysFromScrubber:(NSScrubber *)scrubber {
    BlizzardHSAPIOptionType _Nullable optionType = [self.allScrubbers allKeysForObject:scrubber].firstObject;
    
    if (optionType == nil) return nil;
    
    NSMutableDictionary<NSString *, NSString *> * _Nullable dic = [[self dicFromScrubber:scrubber] mutableCopy];
    [dic removeObjectForKey:@""];
    
    NSComparisonResult (^comparator)(NSString *, NSString *);
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSNumber *lhsNumber = self.factory.slugsAndIds[optionType][lhs];
            NSNumber *rhsNumber = self.factory.slugsAndIds[optionType][rhs];
            return [rhsNumber compare:lhsNumber];
        };
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSString *lhsName = self.factory.slugsAndNames[optionType][lhs];
            NSString *rhsName = self.factory.slugsAndNames[optionType][rhs];
            return [lhsName compare:rhsName];
        };
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost] || [optionType isEqualToString:BlizzardHSAPIOptionTypeAttack] || [optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:lhs.integerValue];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:rhs.integerValue];
            return [lhsNumber compare:rhsNumber];
        };
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSNumber *lhsNumber = [NSNumber numberWithInteger:HSCardCollectibleFromNSString(lhs)];
            NSNumber *rhsNumber = [NSNumber numberWithInteger:HSCardCollectibleFromNSString(rhs)];
            return [lhsNumber compare:rhsNumber];
        };
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSNumber *lhsNumber = self.factory.slugsAndIds[optionType][lhs];
            NSNumber *rhsNumber = self.factory.slugsAndIds[optionType][rhs];
            return [lhsNumber compare:rhsNumber];
        };
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSString *lhsName = self.factory.slugsAndNames[optionType][lhs];
            NSString *rhsName = self.factory.slugsAndNames[optionType][rhs];
            return [lhsName compare:rhsName];
        };
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        comparator = ^NSComparisonResult(NSString *lhs, NSString *rhs) {
            NSString *lhsName = self.factory.slugsAndNames[optionType][lhs];
            NSString *rhsName = self.factory.slugsAndNames[optionType][rhs];
            return [lhsName compare:rhsName];
        };
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
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
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
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
        
//        item.wantsLayer = YES;
//        item.layer.cornerCurve = kCACornerCurveContinuous;
//        item.layer.cornerRadius = 3.0f;
        
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
    
    if (![self.options isEqualToDictionary:newOptions]) {
        [self updateItemsWithOptions:newOptions];
        [self.deckAddCardOptionsTouchBarDelegate deckAddCardOptionsTouchBar:self changedOption:newOptions];
    }
    
    [newOptions release];
}

@end
