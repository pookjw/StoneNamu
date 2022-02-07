//
//  DecksTouchBar.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import "DecksTouchBar.h"
#import "NSTouchBarItemIdentifierDecks+HSDeckFormat.h"
#import <StoneNamuResources/StoneNamuResources.h>

static NSTouchBarCustomizationIdentifier const NSTouchBarCustomizationIdentifierDecksTouchBar = @"NSTouchBarCustomizationIdentifierDecksTouchBar";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier = @"NSUserInterfaceItemIdentifierNSScrubberTextItemViewReuseIdentifier";

@interface DecksTouchBar () <NSTouchBarDelegate, NSScrubberDataSource, NSScrubberDelegate>
@property (assign) id<DecksTouchBarDelegate> decksTouchBarDelegate;
@property (copy) NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSString *> *> *slugsAndNames;
@property (copy) NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSNumber *> *> *slugsAndIds;

@property (retain) NSDictionary<HSDeckFormat, NSPopoverTouchBarItem *> *allPopoverItems;
@property (retain) NSDictionary<HSDeckFormat, NSTouchBar *> *allTouchBarItems;
@property (retain) NSDictionary<HSDeckFormat, NSCustomTouchBarItem *> *allCustomTouchBarItems;
@property (retain) NSDictionary<HSDeckFormat, NSScrubber *> *allScrubberItems;

@property (retain) NSButtonTouchBarItem *createNewDeckFromDeckCodeItem;
@end

@implementation DecksTouchBar

- (instancetype)initWithDecksTouchBarDelegate:(id<DecksTouchBarDelegate>)decksTouchBarDelegate {
    self = [self init];
    
    if (self) {
        self.decksTouchBarDelegate = decksTouchBarDelegate;
        
        self.slugsAndNames = @{};
        self.slugsAndIds = @{};
        
        [self configureItems];
        [self setAttributes];
    }
    
    return self;
}

- (void)dealloc {
    [_slugsAndNames release];
    [_slugsAndIds release];
    
    [_allPopoverItems release];
    [_allTouchBarItems release];
    [_allCustomTouchBarItems release];
    [_allScrubberItems release];
    
    [_createNewDeckFromDeckCodeItem release];
    [super dealloc];
}

- (void)updateWithSlugsAndNames:(NSDictionary<HSDeckFormat,NSDictionary<NSString *,NSString *> *> *)slugsAndNames slugsAndIds:(NSDictionary<HSDeckFormat,NSDictionary<NSString *,NSNumber *> *> *)slugsAndIds {
    self.slugsAndNames = slugsAndNames;
    self.slugsAndIds = slugsAndIds;
    
    [self.allScrubberItems.allValues enumerateObjectsUsingBlock:^(NSScrubber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj reloadData];
    }];
}

- (void)configureItems {
    NSPopoverTouchBarItem *createNewDeckStandardDeckPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDecksCreateNewStandardDeck];
    NSTouchBar *createNewDeckStandardDeckTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *createNewDeckStandardDeckItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDecksCreateNewStandardDeck];
    NSScrubber *createNewDeckStandardDeckScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:createNewDeckStandardDeckPopoverItem
                          touchBar:createNewDeckStandardDeckTouchBar
                        customItem:createNewDeckStandardDeckItem
                          scrubber:createNewDeckStandardDeckScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *createNewDeckWildDeckPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDecksCreateNewWildDeck];
    NSTouchBar *createNewDeckWildDeckTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *createNewDeckWildDeckItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDecksCreateNewWildDeck];
    NSScrubber *createNewDeckWildDeckScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:createNewDeckWildDeckPopoverItem
                          touchBar:createNewDeckWildDeckTouchBar
                        customItem:createNewDeckWildDeckItem
                          scrubber:createNewDeckWildDeckScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)];
    
    //
    
    NSPopoverTouchBarItem *createNewDeckClassicDeckPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDecksCreateNewClassicDeck];
    NSTouchBar *createNewDeckClassicDeckTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *createNewDeckClassicDeckItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDecksCreateNewClassicDeck];
    NSScrubber *createNewDeckClassicDeckScrubber = [NSScrubber new];
    
    [self wireItemsWithPopoverItem:createNewDeckClassicDeckPopoverItem
                          touchBar:createNewDeckClassicDeckTouchBar
                        customItem:createNewDeckClassicDeckItem
                          scrubber:createNewDeckClassicDeckScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)];
    
    //
    
    NSButtonTouchBarItem *createNewDeckFromDeckCodeItem = [[NSButtonTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDecksCreateNewDeckFromDeckCode];
    createNewDeckFromDeckCodeItem.target = self;
    createNewDeckFromDeckCodeItem.action = @selector(createNewDeckFromDeckCodeItemTriggered:);
    createNewDeckFromDeckCodeItem.title = [ResourcesService localizationForKey:LocalizableKeyLoadFromDeckCode];
    createNewDeckFromDeckCodeItem.image = [NSImage imageWithSystemSymbolName:@"chevron.left.forwardslash.chevron.right" accessibilityDescription:nil];

    //
    
    self.allPopoverItems = @{
        HSDeckFormatStandard: createNewDeckStandardDeckPopoverItem,
        HSDeckFormatWild: createNewDeckWildDeckPopoverItem,
        HSDeckFormatClassic: createNewDeckClassicDeckPopoverItem
    };
    
    self.allTouchBarItems = @{
        HSDeckFormatStandard: createNewDeckStandardDeckTouchBar,
        HSDeckFormatWild: createNewDeckWildDeckTouchBar,
        HSDeckFormatClassic: createNewDeckClassicDeckTouchBar
    };
    
    self.allCustomTouchBarItems = @{
        HSDeckFormatStandard: createNewDeckStandardDeckItem,
        HSDeckFormatWild: createNewDeckWildDeckItem,
        HSDeckFormatClassic: createNewDeckClassicDeckItem
    };
    
    self.allScrubberItems = @{
        HSDeckFormatStandard: createNewDeckStandardDeckScrubber,
        HSDeckFormatWild: createNewDeckWildDeckScrubber,
        HSDeckFormatClassic: createNewDeckClassicDeckScrubber
    };
    
    self.createNewDeckFromDeckCodeItem = createNewDeckFromDeckCodeItem;

    [createNewDeckStandardDeckPopoverItem release];
    [createNewDeckStandardDeckTouchBar release];
    [createNewDeckStandardDeckItem release];
    [createNewDeckStandardDeckScrubber release];
    
    [createNewDeckWildDeckPopoverItem release];
    [createNewDeckWildDeckTouchBar release];
    [createNewDeckWildDeckItem release];
    [createNewDeckWildDeckScrubber release];
    
    [createNewDeckClassicDeckPopoverItem release];
    [createNewDeckClassicDeckTouchBar release];
    [createNewDeckClassicDeckItem release];
    [createNewDeckClassicDeckScrubber release];
    
    [createNewDeckFromDeckCodeItem release];
}

- (void)setAttributes {
    self.delegate = self;
    self.customizationIdentifier = NSTouchBarCustomizationIdentifierDecksTouchBar;
    self.defaultItemIdentifiers = allNSTouchBarItemIdentifierDecks();
    self.customizationAllowedItemIdentifiers = allNSTouchBarItemIdentifierDecks();
}

- (void)wireItemsWithPopoverItem:(NSPopoverTouchBarItem *)popoverItem
                        touchBar:(NSTouchBar *)touchBar
                      customItem:(NSCustomTouchBarItem *)customItem
                        scrubber:(NSScrubber *)scrubber
                        itemSize:(CGSize)itemSize {
    
    NSTouchBarItemIdentifier itemIdentifier = popoverItem.identifier;
    HSDeckFormat deckFormat = HSDeckFormatFromNSTouchBarItemIdentifierDecks(itemIdentifier);
    
    popoverItem.collapsedRepresentationImage = [ResourcesService imageForDeckFormat:deckFormat];
    popoverItem.collapsedRepresentationLabel = [ResourcesService localizationForHSDeckFormat:deckFormat];
    popoverItem.customizationLabel = [ResourcesService localizationForHSDeckFormat:deckFormat];
    popoverItem.popoverTouchBar = touchBar;
    popoverItem.pressAndHoldTouchBar = touchBar;
    touchBar.delegate = self;
    touchBar.defaultItemIdentifiers = @[customItem.identifier];
    
    customItem.view = scrubber;
    scrubber.backgroundColor = NSColor.clearColor;
    scrubber.mode = NSScrubberModeFree;
    scrubber.floatsSelectionViews = NO;
    scrubber.selectionOverlayStyle = nil;
    scrubber.selectionBackgroundStyle = nil;
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

- (void)createNewDeckFromDeckCodeItemTriggered:(NSButtonTouchBarItem *)sender {
    [self.decksTouchBarDelegate decksTouchBar:self createNewDeckFromDeckCodeWithIdentifier:sender.identifier];
}

#pragma mark - Helper

- (NSDictionary<NSString *, NSString *> *)dicFromScrubber:(NSScrubber *)scrubber {
    HSDeckFormat hsDeckFormat = [self hsDeckFormatFromScrubber:scrubber];
    return self.slugsAndNames[hsDeckFormat];
}

- (NSArray<NSString *> *)sortedKeysFromScrubber:(NSScrubber *)scrubber {
    NSArray<NSString *> *keys = [[self dicFromScrubber:scrubber].allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    return keys;
}

- (HSDeckFormat)hsDeckFormatFromScrubber:(NSScrubber *)scrubber {
    return [self.allScrubberItems allKeysForObject:scrubber].firstObject;
}

- (NSPopoverTouchBarItem *)popoverTouchBarItemFromScrubber:(NSScrubber *)scrubber {
    HSDeckFormat hsDeckFormat = [self hsDeckFormatFromScrubber:scrubber];
    return self.allPopoverItems[hsDeckFormat];
}

#pragma mark - NSTouchBarDelegate

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    if ([touchBar isEqual:self]) {
        NSPopoverTouchBarItem * _Nullable __block result = nil;
        
        [self.allPopoverItems.allValues enumerateObjectsUsingBlock:^(NSPopoverTouchBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([identifier isEqualToString:obj.identifier]) {
                result = obj;
                *stop = YES;
            }
        }];
        
        return result;
    } else {
        HSDeckFormat _Nullable hsDeckFormat = [self.allTouchBarItems allKeysForObject:touchBar].firstObject;
        
        if (hsDeckFormat == nil) return nil;
        
        return self.allCustomTouchBarItems[hsDeckFormat];
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
    
    if (keys != nil) {
        title = dic[key];
    }
    
    if (title != nil) {
        item.title = title;
    }
    
    return item;
}

#pragma mark - NSScrubberDelegate

- (void)scrubber:(NSScrubber *)scrubber didSelectItemAtIndex:(NSInteger)selectedIndex {
    HSDeckFormat deckFormat = [self hsDeckFormatFromScrubber:scrubber];
    NSArray<NSString *> *keys = [self sortedKeysFromScrubber:scrubber];
    NSString * _Nullable key = keys[selectedIndex];
    
    if (key == nil) return;
    
    [[self popoverTouchBarItemFromScrubber:scrubber] dismissPopover:nil];
    [self.decksTouchBarDelegate decksTouchBar:self createNewDeckWithDeckFormat:deckFormat classSlug:key];
    
}

@end
