//
//  DecksToolbar.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import "DecksToolbar.h"
#import "DynamicMenuToolbarItem.h"
#import "NSToolbarIdentifierDecks+HSDeckFormat.h"
#import "DecksMenuFactory.h"
#import "StorableMenuItem.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DecksToolbar () <NSToolbarDelegate>
@property (assign) id<DecksToolbarDelegate> decksToolbarDelegate;
@property (retain) DecksMenuFactory *factory;

@property (retain) DynamicMenuToolbarItem *createNewDeckStandardDeckItem;
@property (retain) DynamicMenuToolbarItem *createNewDeckWildDeckItem;
@property (retain) DynamicMenuToolbarItem *createNewDeckClassicDeckItem;
@property (retain) DynamicMenuToolbarItem *createNewDeckFromDeckCodeItem;
@property (retain) NSArray<DynamicMenuToolbarItem *> *allItems;
@property (retain) NSDictionary<HSDeckFormat, DynamicMenuToolbarItem *> *allHSDeckFormatItems;
@end

@implementation DecksToolbar

- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier decksToolbarDelegate:(id<DecksToolbarDelegate>)decksToolbarDelegate {
    self = [self initWithIdentifier:identifier];
    
    if (self) {
        self.decksToolbarDelegate = decksToolbarDelegate;
        
        DecksMenuFactory *factory = [DecksMenuFactory new];
        self.factory = factory;
        [factory release];
        
        [self setAttributes];
        [self configureToolbarItems];
        
        [self bind];
        [self.factory load];
    }
    
    return self;
}

- (void)dealloc {
    [_factory release];
    [_createNewDeckStandardDeckItem release];
    [_createNewDeckWildDeckItem release];
    [_createNewDeckClassicDeckItem release];
    [_createNewDeckFromDeckCodeItem release];
    [_allItems release];
    [_allHSDeckFormatItems release];
    [super dealloc];
}

- (void)setAttributes {
    self.delegate = self;
    self.allowsUserCustomization = YES;
    self.autosavesConfiguration = YES;
}

- (void)configureToolbarItems {
    DynamicMenuToolbarItem *createNewDeckStandardDeckItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDecksCreateNewStandardDeck];
    createNewDeckStandardDeckItem.title = [ResourcesService localizationForHSDeckFormat:HSDeckFormatStandard];
    createNewDeckStandardDeckItem.image = [ResourcesService imageForDeckFormat:HSDeckFormatStandard];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDecksCreateNewStandardDeck atIndex:0];
    
    DynamicMenuToolbarItem *createNewDeckWildDeckItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDecksCreateNewWildDeck];
    createNewDeckWildDeckItem.title = [ResourcesService localizationForHSDeckFormat:HSDeckFormatWild];
    createNewDeckWildDeckItem.image = [ResourcesService imageForDeckFormat:HSDeckFormatWild];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDecksCreateNewWildDeck atIndex:1];
    
    DynamicMenuToolbarItem *createNewDeckClassicDeckItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDecksCreateNewClassicDeck];
    createNewDeckClassicDeckItem.title = [ResourcesService localizationForHSDeckFormat:HSDeckFormatClassic];
    createNewDeckClassicDeckItem.image = [ResourcesService imageForDeckFormat:HSDeckFormatClassic];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDecksCreateNewClassicDeck atIndex:2];
    
    DynamicMenuToolbarItem *createNewDeckFromDeckCodeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDecksCreateNewDeckFromDeckCode];
    createNewDeckFromDeckCodeItem.title = [ResourcesService localizationForKey:LocalizableKeyLoadFromDeckCode];
    createNewDeckFromDeckCodeItem.image = [NSImage imageWithSystemSymbolName:@"chevron.left.forwardslash.chevron.right" accessibilityDescription:nil];
    createNewDeckFromDeckCodeItem.showsIndicator = NO;
    createNewDeckFromDeckCodeItem.target = self;
    createNewDeckFromDeckCodeItem.action = @selector(createNewDeckFromDeckCodeItemTriggered:);
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDecksCreateNewDeckFromDeckCode atIndex:3];
    
    self.allItems = @[
        createNewDeckStandardDeckItem,
        createNewDeckWildDeckItem,
        createNewDeckClassicDeckItem,
        createNewDeckFromDeckCodeItem
    ];
    
    self.allHSDeckFormatItems = @{
        HSDeckFormatStandard: createNewDeckStandardDeckItem,
        HSDeckFormatWild: createNewDeckWildDeckItem,
        HSDeckFormatClassic: createNewDeckClassicDeckItem
    };
    
    self.createNewDeckStandardDeckItem = createNewDeckStandardDeckItem;
    self.createNewDeckWildDeckItem = createNewDeckWildDeckItem;
    self.createNewDeckClassicDeckItem = createNewDeckClassicDeckItem;
    self.createNewDeckFromDeckCodeItem = createNewDeckFromDeckCodeItem;
    
    [createNewDeckStandardDeckItem release];
    [createNewDeckWildDeckItem release];
    [createNewDeckClassicDeckItem release];
    [createNewDeckFromDeckCodeItem release];
    
    [self validateVisibleItems];
}

- (void)keyMenuItemTriggered:(StorableMenuItem *)sender {
    HSDeckFormat hsDeckFormat = sender.userInfo.allKeys.firstObject;
    NSString *classSlug = sender.userInfo.allValues.firstObject;
    
    [self.decksToolbarDelegate decksToolbar:self createNewDeckWithDeckFormat:hsDeckFormat classSlug:classSlug];
}

- (void)createNewDeckFromDeckCodeItemTriggered:(DynamicMenuToolbarItem *)sender {
    [self.decksToolbarDelegate decksToolbar:self createNewDeckFromDeckCodeWithIdentifier:sender.itemIdentifier];
}

#pragma mark - NSToolbarDelegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    NSMenuToolbarItem * _Nullable __block resultItem = nil;
    
    [self.allHSDeckFormatItems.allValues enumerateObjectsUsingBlock:^(DynamicMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([itemIdentifier isEqualToString:obj.itemIdentifier]) {
            resultItem = obj;
            *stop = YES;
        }
    }];
    
    return resultItem;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return allNSToolbarIdentifierDecks();
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return allNSToolbarIdentifierDecks();
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shouldUpdateReceived:)
                                               name:NSNotificationNameDecksMenuFactoryShouldUpdateItems
                                             object:self.factory];
}

- (void)shouldUpdateReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.allHSDeckFormatItems enumerateKeysAndObjectsUsingBlock:^(HSDeckFormat  _Nonnull key, DynamicMenuToolbarItem * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.menu = [self.factory menuForHSDeckFormat:key target:self];
        }];
    }];
}

@end
