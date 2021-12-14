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
@property (retain) NSArray<NSTouchBarItem *> *allItems;

@property (retain) NSPopoverTouchBarItem *createNewDeckStandardDeckPopoverItem;
@property (retain) NSTouchBar *createNewDeckStandardDeckTouchBar;
@property (retain) NSCustomTouchBarItem *createNewDeckStandardDeckItem;
@property (retain) NSScrubber *createNewDeckStandardDeckScrubber;

@property (retain) NSPopoverTouchBarItem *createNewDeckWildDeckPopoverItem;
@property (retain) NSTouchBar *createNewDeckWildDeckTouchBar;
@property (retain) NSCustomTouchBarItem *createNewDeckWildDeckItem;
@property (retain) NSScrubber *createNewDeckWildDeckScrubber;

@property (retain) NSPopoverTouchBarItem *createNewDeckClassicDeckPopoverItem;
@property (retain) NSTouchBar *createNewDeckClassicDeckTouchBar;
@property (retain) NSCustomTouchBarItem *createNewDeckClassicDeckItem;
@property (retain) NSScrubber *createNewDeckClassicDeckScrubber;

@property (retain) NSButtonTouchBarItem *createNewDeckFromDeckCodeItem;
@end

@implementation DecksTouchBar

- (instancetype)initWithDecksTouchBarDelegate:(id<DecksTouchBarDelegate>)decksTouchBarDelegate {
    self = [self init];
    
    if (self) {
        self.decksTouchBarDelegate = decksTouchBarDelegate;
        
        [self configureItems];
        [self setAttributes];
    }
    
    return self;
}

- (void)dealloc {
    [_allItems release];
    
    [_createNewDeckStandardDeckPopoverItem release];
    [_createNewDeckStandardDeckTouchBar release];
    [_createNewDeckStandardDeckItem release];
    [_createNewDeckStandardDeckScrubber release];
    
    [_createNewDeckWildDeckPopoverItem release];
    [_createNewDeckWildDeckTouchBar release];
    [_createNewDeckWildDeckItem release];
    [_createNewDeckWildDeckScrubber release];
    
    [_createNewDeckClassicDeckPopoverItem release];
    [_createNewDeckClassicDeckTouchBar release];
    [_createNewDeckClassicDeckItem release];
    [_createNewDeckClassicDeckScrubber release];
    
    [_createNewDeckFromDeckCodeItem release];
    [super dealloc];
}

- (void)configureItems {
    NSPopoverTouchBarItem *createNewDeckStandardDeckPopoverItem = [[NSPopoverTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDecksCreateNewStandardDeck];
    NSTouchBar *createNewDeckStandardDeckTouchBar = [NSTouchBar new];
    NSCustomTouchBarItem *createNewDeckStandardDeckItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDecksCreateNewStandardDeck];
    NSScrubber *createNewDeckStandardDeckScrubber = [NSScrubber new];
    self.createNewDeckStandardDeckPopoverItem = createNewDeckStandardDeckPopoverItem;
    self.createNewDeckStandardDeckTouchBar = createNewDeckStandardDeckTouchBar;
    self.createNewDeckStandardDeckItem = createNewDeckStandardDeckItem;
    self.createNewDeckStandardDeckScrubber = createNewDeckStandardDeckScrubber;
    
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
    self.createNewDeckWildDeckPopoverItem = createNewDeckWildDeckPopoverItem;
    self.createNewDeckWildDeckTouchBar = createNewDeckWildDeckTouchBar;
    self.createNewDeckWildDeckItem = createNewDeckWildDeckItem;
    self.createNewDeckWildDeckScrubber = createNewDeckWildDeckScrubber;
    
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
    self.createNewDeckClassicDeckPopoverItem = createNewDeckClassicDeckPopoverItem;
    self.createNewDeckClassicDeckTouchBar = createNewDeckClassicDeckTouchBar;
    self.createNewDeckClassicDeckItem = createNewDeckClassicDeckItem;
    self.createNewDeckClassicDeckScrubber = createNewDeckClassicDeckScrubber;
    
    [self wireItemsWithPopoverItem:createNewDeckClassicDeckPopoverItem
                          touchBar:createNewDeckClassicDeckTouchBar
                        customItem:createNewDeckClassicDeckItem
                          scrubber:createNewDeckClassicDeckScrubber
                          itemSize:CGSizeMake(150.0f, 30.0f)];
    
    //
    
    NSButtonTouchBarItem *createNewDeckFromDeckCodeItem = [[NSButtonTouchBarItem alloc] initWithIdentifier:NSTouchBarItemIdentifierDecksCreateNewDeckFromDeckCode];
    self.createNewDeckFromDeckCodeItem = createNewDeckFromDeckCodeItem;
    createNewDeckFromDeckCodeItem.target = self;
    createNewDeckFromDeckCodeItem.action = @selector(createNewDeckFromDeckCodeItemTriggered:);
    createNewDeckFromDeckCodeItem.title = [ResourcesService localizationForKey:LocalizableKeyLoadFromDeckCode];
    createNewDeckFromDeckCodeItem.image = [NSImage imageWithSystemSymbolName:@"chevron.left.forwardslash.chevron.right" accessibilityDescription:nil];

    //

    self.allItems = @[createNewDeckStandardDeckPopoverItem,
                      createNewDeckWildDeckPopoverItem,
                      createNewDeckClassicDeckPopoverItem,
                      createNewDeckFromDeckCodeItem];

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
    if ([scrubber isEqual:self.createNewDeckStandardDeckScrubber]) {
        return [ResourcesService localizationsForHSCardClassForFormat:HSDeckFormatStandard];
    } else if ([scrubber isEqual:self.createNewDeckWildDeckScrubber]) {
        return [ResourcesService localizationsForHSCardClassForFormat:HSDeckFormatWild];
    } else if ([scrubber isEqual:self.createNewDeckClassicDeckScrubber]) {
        return [ResourcesService localizationsForHSCardClassForFormat:HSDeckFormatClassic];
    } else {
        return @{};
    }
}

- (NSArray<NSString *> *)sortedKeysFromScrubber:(NSScrubber *)scrubber {
    NSArray<NSString *> *keys = [[self dicFromScrubber:scrubber].allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
        HSCardClass lhs = HSCardClassFromNSString(obj1);
        HSCardClass rhs = HSCardClassFromNSString(obj2);
        
        if (lhs < rhs) {
            return NSOrderedAscending;
        } else if (lhs > rhs) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    return keys;
}

- (HSDeckFormat)hsDeckFormatFromScrubber:(NSScrubber *)scrubber {
    if ([scrubber isEqual:self.createNewDeckStandardDeckScrubber]) {
        return HSDeckFormatStandard;
    } else if ([scrubber isEqual:self.createNewDeckWildDeckScrubber]) {
        return HSDeckFormatWild;
    } else if ([scrubber isEqual:self.createNewDeckClassicDeckScrubber]) {
        return HSDeckFormatClassic;
    } else {
        return nil;
    }
}

- (NSPopoverTouchBarItem *)popoverTouchBarItemFromScrubber:(NSScrubber *)scrubber {
    if ([scrubber isEqual:self.createNewDeckStandardDeckScrubber]) {
        return self.createNewDeckStandardDeckPopoverItem;
    } else if ([scrubber isEqual:self.createNewDeckWildDeckScrubber]) {
        return self.createNewDeckWildDeckPopoverItem;
    } else if ([scrubber isEqual:self.createNewDeckClassicDeckScrubber]) {
        return self.createNewDeckClassicDeckPopoverItem;
    } else {
        return nil;
    }
}

#pragma mark - NSTouchBarDelegate

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    if ([touchBar isEqual:self]) {
        NSTouchBarItem * _Nullable __block result = nil;
        
        [self.allItems enumerateObjectsUsingBlock:^(NSTouchBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([identifier isEqualToString:obj.identifier]) {
                result = obj;
                *stop = YES;
            }
        }];
        
        return result;
    } else if ([touchBar isEqual:self.createNewDeckStandardDeckTouchBar]) {
        return self.createNewDeckStandardDeckItem;
    } else if ([touchBar isEqual:self.createNewDeckWildDeckTouchBar]) {
        return self.createNewDeckWildDeckItem;
    } else if ([touchBar isEqual:self.createNewDeckClassicDeckTouchBar]) {
        return self.createNewDeckClassicDeckItem;
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
    
    [[self popoverTouchBarItemFromScrubber:scrubber] dismissPopover:nil];
    [self.decksTouchBarDelegate decksTouchBar:self createNewDeckWithDeckFormat:deckFormat hsCardClass:HSCardClassFromNSString(keys[selectedIndex])];
    
}

@end
