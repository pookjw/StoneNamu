//
//  DecksMenu.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/27/21.
//

#import "DecksMenu.h"
#import "DecksMenuFactory.h"
#import "StorableMenuItem.h"
#import "NSUserInterfaceItemIdentifierDecks+HSDeckFormat.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DecksMenu ()
@property (assign) id<DecksMenuDelegate> decksMenuDelegate;

@property (retain) NSMenuItem *createNewDeckStandardDeckItem;
@property (retain) NSMenuItem *createNewDeckWildDeckItem;
@property (retain) NSMenuItem *createNewDeckClassicDeckItem;
@property (retain) NSMenuItem *createNewDeckFromDeckCodeItem;

@property (retain) NSArray<NSMenuItem *> *allItems;
@end

@implementation DecksMenu

- (instancetype)initWithDecksMenuDelegate:(id<DecksMenuDelegate>)decksMenuDelegate {
    self = [self init];
    
    if (self) {
        self.decksMenuDelegate = decksMenuDelegate;
        
        [self configureCreateDeckItems];
    }
    
    return self;
}

- (void)dealloc {
    [_createNewDeckStandardDeckItem release];
    [_createNewDeckWildDeckItem release];
    [_createNewDeckClassicDeckItem release];
    [_createNewDeckFromDeckCodeItem release];
    [_allItems release];
    [super dealloc];
}

- (void)configureCreateDeckItems {
    NSMenu *fileSubMenu = self.fileMenuItem.submenu;
    NSMenuItem *createDeckMenuItem = [[NSMenuItem alloc] initWithTitle:@"Create New Deck... (Demo)" action:nil keyEquivalent:@""];
    NSMenu *createDeckMenu = [NSMenu new];
    
    //
    
    fileSubMenu.itemArray = [fileSubMenu.itemArray arrayByAddingObject:createDeckMenuItem];
    createDeckMenuItem.submenu = createDeckMenu;
    
    //
    
    NSMenuItem *createNewDeckStandardDeckItem = [[NSMenuItem alloc] initWithTitle:@"Create Standard Deck (Demo)" action:nil keyEquivalent:@""];
    createNewDeckStandardDeckItem.submenu = [DecksMenuFactory menuForHSDeckFormat:HSDeckFormatStandard target:self];
    createNewDeckStandardDeckItem.identifier = NSUserInterfaceItemIdentifierDecksCreateNewStandardDeck;
    
    NSMenuItem *createNewDeckWildDeckItem = [[NSMenuItem alloc] initWithTitle:@"Create Wild Deck (Demo)" action:nil keyEquivalent:@""];
    createNewDeckWildDeckItem.submenu = [DecksMenuFactory menuForHSDeckFormat:HSDeckFormatWild target:self];
    createNewDeckWildDeckItem.identifier = NSUserInterfaceItemIdentifierDecksCreateNewWildDeck;
    
    NSMenuItem *createNewDeckClassicDeckItem = [[NSMenuItem alloc] initWithTitle:@"Create Classic Deck" action:nil keyEquivalent:@""];
    createNewDeckClassicDeckItem.submenu = [DecksMenuFactory menuForHSDeckFormat:HSDeckFormatClassic target:self];
    createNewDeckClassicDeckItem.identifier = NSUserInterfaceItemIdentifierDecksCreateNewClassicDeck;
    
    NSMenuItem *createNewDeckFromDeckCodeItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyLoadFromDeckCode] action:@selector(createNewDeckFromDeckCodeItemTriggered:) keyEquivalent:@""];
    createNewDeckFromDeckCodeItem.target = self;
    createNewDeckFromDeckCodeItem.identifier = NSUserInterfaceItemIdentifierDecksCreateNewDeckFromDeckCode;
    
    createDeckMenu.itemArray = @[createNewDeckStandardDeckItem, createNewDeckWildDeckItem, createNewDeckClassicDeckItem, createNewDeckFromDeckCodeItem];
    
    //
    
    [createDeckMenuItem release];
    [createDeckMenu release];
    
    [createNewDeckStandardDeckItem release];
    [createNewDeckWildDeckItem release];
    [createNewDeckClassicDeckItem release];
    [createNewDeckFromDeckCodeItem release];
}

- (void)keyMenuItemTriggered:(StorableMenuItem *)sender {
    HSDeckFormat hsDeckFormat = sender.userInfo.allKeys.firstObject;
    HSCardClass hsCardClass = HSCardClassFromNSString(sender.userInfo.allValues.firstObject);
    [self.decksMenuDelegate decksMenu:self createNewDeckWithDeckFormat:hsDeckFormat hsCardClass:hsCardClass];
}

- (void)createNewDeckFromDeckCodeItemTriggered:(NSMenuItem *)sender {
    [self.decksMenuDelegate decksMenu:self createNewDeckFromDeckCodeWithIdentifier:sender.identifier];
}

@end
