//
//  CardOptionsTouchBar.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import "CardOptionsTouchBar.h"
#import "NSTouchBarItemIdentifierCardOptions+BlizzardHSAPIOptionType.h"

static NSTouchBarCustomizationIdentifier const NSTouchBarCustomizationIdentifierCardOptionsTouchBar = @"NSTouchBarCustomizationIdentifierCardOptionsTouchBar";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier = @"NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier";

@interface CardOptionsTouchBar () <NSTouchBarDelegate, NSScrubberDataSource, NSScrubberDelegate>
@property (weak) id<CardOptionsTouchBarDelegate> cardOptionsTouchBarDelegate;
@property (retain) NSArray<NSTouchBarItem *> *allItems;
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
@property (retain) NSScrubber *optionTypeHealthItemScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeCollectiblePopoverItem;
@property (retain) NSTouchBar *optionTypeCollectibleTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeCollectibleItem;
@property (retain) NSScrubber *optionTypeCollectibleItemScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeRarityPopoverItem;
@property (retain) NSTouchBar *optionTypeRarityTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeRarityItem;
@property (retain) NSScrubber *optionTypeRarityItemScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeTypePopoverItem;
@property (retain) NSTouchBar *optionTypeTypeTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeTypeItem;
@property (retain) NSScrubber *optionTypTypeItemScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeMinionTypePopoverItem;
@property (retain) NSTouchBar *optionTypeMinionTypeTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeMinionTypeItem;
@property (retain) NSScrubber *optionTypeMinionTypeScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeKeywordPopoverItem;
@property (retain) NSTouchBar *optionTypeKeywordTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeKeywordItem;
@property (retain) NSScrubber *optionTypeKeywordScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypeGameModePopoverItem;
@property (retain) NSTouchBar *optionTypeGameModeTouchBar;
@property (retain) NSCustomTouchBarItem *optionTypeGameModeItem;
@property (retain) NSScrubber *optionTypeGameModeScrubber;

@property (retain) NSPopoverTouchBarItem *optionTypSortPopoverItem;
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
    [_allItems release];
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
    [_optionTypeHealthItemScrubber release];
    
    [_optionTypeCollectiblePopoverItem release];
    [_optionTypeCollectibleTouchBar release];
    [_optionTypeCollectibleItem release];
    [_optionTypeCollectibleItemScrubber release];
    
    [_optionTypeRarityPopoverItem release];
    [_optionTypeRarityTouchBar release];
    [_optionTypeRarityItem release];
    [_optionTypeRarityItemScrubber release];
    
    [_optionTypeTypePopoverItem release];
    [_optionTypeTypeTouchBar release];
    [_optionTypeTypeItem release];
    [_optionTypTypeItemScrubber release];
    
    [_optionTypeMinionTypePopoverItem release];
    [_optionTypeMinionTypeTouchBar release];
    [_optionTypeMinionTypeItem release];
    [_optionTypeMinionTypeScrubber release];
    
    [_optionTypeKeywordPopoverItem release];
    [_optionTypeKeywordTouchBar release];
    [_optionTypeKeywordItem release];
    [_optionTypeKeywordScrubber release];
    
    [_optionTypeGameModePopoverItem release];
    [_optionTypeGameModeTouchBar release];
    [_optionTypeGameModeItem release];
    [_optionTypeGameModeScrubber release];
    
    [_optionTypSortPopoverItem release];
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
    NSCustomTouchBarItem *optionTypeSetItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierCardOptionsTypeSet];;
    NSScrubber *optionTypeSetScrubber = [NSScrubber new];
    NSScrubberFlowLayout *optionTypeSetScrubberLayout = [NSScrubberFlowLayout new];
    self.optionTypeSetPopoverItem = optionTypeSetPopoverItem;
    self.optionTypeSetTouchBar = optionTypeSetTouchBar;
    self.optionTypeSetItem = optionTypeSetItem;
    self.optionTypeSetScrubber = optionTypeSetScrubber;
    
    optionTypeSetPopoverItem.collapsedRepresentationImage = [NSImage imageWithSystemSymbolName:PrefferedSystemSymbolFromBlizzardHSAPIDefaultOptions(BlizzardHSAPIOptionTypeSet) accessibilityDescription:nil];
    optionTypeSetPopoverItem.customizationLabel = NSLocalizedString(@"CARD_SET", @"");
    optionTypeSetPopoverItem.collapsedRepresentationLabel = NSLocalizedString(@"CARD_SET", @"");
    optionTypeSetPopoverItem.popoverTouchBar = optionTypeSetTouchBar;
    optionTypeSetPopoverItem.pressAndHoldTouchBar = optionTypeSetTouchBar;
    optionTypeSetTouchBar.delegate = self;
    optionTypeSetTouchBar.defaultItemIdentifiers = @[NSTouchBarItemIdentifierCardOptionsTypeSet];
    optionTypeSetItem.view = optionTypeSetScrubber;
    optionTypeSetScrubber.backgroundColor = NSColor.darkGrayColor;
    optionTypeSetScrubber.mode = NSScrubberModeFree;
    optionTypeSetScrubber.scrubberLayout = optionTypeSetScrubberLayout;
    optionTypeSetScrubber.selectionOverlayStyle = [NSScrubberSelectionStyle outlineOverlayStyle];
    optionTypeSetScrubber.continuous = NO;
    optionTypeSetScrubber.showsArrowButtons = YES;
    [optionTypeSetScrubber registerClass:[NSScrubberTextItemView class] forItemIdentifier:NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier];
    optionTypeSetScrubber.dataSource = self;
    optionTypeSetScrubber.delegate = self;
    optionTypeSetScrubberLayout.itemSize = CGSizeMake(230.0f, 30.0f);
    
    self.allItems = @[
        optionTypeSetPopoverItem
    ];
    
    [optionTypeSetPopoverItem release];
    [optionTypeSetTouchBar release];
    [optionTypeSetItem release];
    [optionTypeSetScrubber release];
    [optionTypeSetScrubberLayout release];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *,NSString *> *)options {
    NSMutableDictionary<NSString *, NSString *> *mutableOptions = [options mutableCopy];
    self.options = mutableOptions;
    [mutableOptions release];
}

#pragma mark - NSTouchBarDelegate

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    if ([touchBar isEqualTo:self]) {
        NSTouchBarItem * _Nullable __block result = nil;
        
        [self.allItems enumerateObjectsUsingBlock:^(NSTouchBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([identifier isEqualToString:obj.identifier]) {
                result = obj;
                *stop = YES;
            }
        }];
        
        return result;
    } else if ([touchBar isEqualTo:self.optionTypeSetTouchBar]) {
        return self.optionTypeSetItem;
    } else {
        return nil;
    }
}

#pragma mark - NSScrubberDataSource

- (NSInteger)numberOfItemsForScrubber:(NSScrubber *)scrubber {
    if ([scrubber isEqualTo:self.optionTypeSetScrubber]) {
        return hsCardSets().count;
    } else {
        return 0;
    }
}

- (__kindof NSScrubberItemView *)scrubber:(NSScrubber *)scrubber viewForItemAtIndex:(NSInteger)index {
    NSScrubberTextItemView *item = [scrubber makeItemWithIdentifier:NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier owner:nil];
    
    if ([scrubber isEqualTo:self.optionTypeSetScrubber]) {
        NSDictionary<NSString *, NSString *> *dic = hsCardSetsWithLocalizable();
        NSArray<NSString *> *keys = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HSCardSet lhs = HSCardSetFromNSString(obj1);
            HSCardSet rhs = HSCardSetFromNSString(obj2);
            
            if (lhs < rhs) {
                return NSOrderedDescending;
            } else if (lhs > rhs) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }];
        
        item.title = dic[keys[index]];
    }
    
    return item;
}

#pragma mark - NSScrubberDelegate

- (void)scrubber:(NSScrubber *)scrubber didSelectItemAtIndex:(NSInteger)selectedIndex {
    if ([scrubber isEqualTo:self.optionTypeSetScrubber]) {
        NSDictionary<NSString *, NSString *> *dic = hsCardSetsWithLocalizable();
        NSArray<NSString *> *keys = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HSCardSet lhs = HSCardSetFromNSString(obj1);
            HSCardSet rhs = HSCardSetFromNSString(obj2);
            
            if (lhs < rhs) {
                return NSOrderedDescending;
            } else if (lhs > rhs) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        }];
        self.options[BlizzardHSAPIOptionTypeSet] = keys[selectedIndex];
        [self updateItemsWithOptions:self.options];
        [self.cardOptionsTouchBarDelegate cardOptionsTouchBar:self changedOption:self.options];
    }
}

@end
