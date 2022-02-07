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
@property (retain) DecksMenuFactory *factory;

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
        
        DecksMenuFactory *factory = [DecksMenuFactory new];
        self.factory = factory;
        [factory release];
        
        [self.editMenuItem.submenu addItem:[NSMenuItem separatorItem]];
        [self configureEditDeckNameItem];
        [self configureDeleteItem];
        
        [self configureCreateDeckItems];
    }
    
    return self;
}

- (void)dealloc {
    [_factory release];
    [_editDeckNameItem release];
    [_deleteItem release];
    [_createNewDeckStandardDeckItem release];
    [_createNewDeckWildDeckItem release];
    [_createNewDeckClassicDeckItem release];
    [_createNewDeckFromDeckCodeItem release];
    [_allItems release];
    [super dealloc];
}

- (void)updateWithSlugsAndNames:(NSDictionary<HSDeckFormat,NSDictionary<NSString *,NSString *> *> *)slugsAndNames slugsAndIds:(NSDictionary<HSDeckFormat,NSDictionary<NSString *,NSNumber *> *> *)slugsAndIds {
    self.factory.slugsAndNames = slugsAndNames;
    self.factory.slugsAndIds = slugsAndIds;
    
    [self.allItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUserInterfaceItemIdentifier itemIdentifier = obj.identifier;
        HSDeckFormat hsDeckFormat = HSDeckFormatFromNSUserInterfaceItemIdentifierDecks(itemIdentifier);
        obj.submenu = [self.factory menuForHSDeckFormat:hsDeckFormat target:self];
    }];
}

- (void)configureEditDeckNameItem {
    NSMenuItem *editDeckNameItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyEditDeckName]
                                                              action:NSSelectorFromString(@"editDeckNameItemTriggered:")
                                                       keyEquivalent:@""];
    
    [self.editMenuItem.submenu addItem:editDeckNameItem];
    
    [self->_editDeckNameItem release];
    self->_editDeckNameItem = [editDeckNameItem retain];
    [editDeckNameItem release];
}

- (void)configureDeleteItem {
    NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDeleteDeck]
                                                        action:NSSelectorFromString(@"deleteItemTriggered:")
                                                 keyEquivalent:@""];
    
    [self.editMenuItem.submenu addItem:deleteItem];
    
    [self->_deleteItem release];
    self->_deleteItem = [deleteItem retain];
    [deleteItem release];
}

- (void)configureCreateDeckItems {
    NSMenu *fileSubMenu = self.fileMenuItem.submenu;
    NSMenuItem *createDeckMenuItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyFileMenuCreateANewDeck]
                                                                action:nil
                                                         keyEquivalent:@""];
    NSMenu *createDeckMenu = [NSMenu new];
    
    //
    
    
    fileSubMenu.itemArray = [fileSubMenu.itemArray arrayByAddingObjectsFromArray:@[[NSMenuItem separatorItem],
                                                                                    createDeckMenuItem]];
    createDeckMenuItem.submenu = createDeckMenu;
    
    //
    
    NSMenuItem *createNewDeckStandardDeckItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForHSDeckFormat:HSDeckFormatStandard]
                                                                           action:nil
                                                                    keyEquivalent:@""];
    createNewDeckStandardDeckItem.identifier = NSUserInterfaceItemIdentifierDecksCreateNewStandardDeck;
    
    NSMenuItem *createNewDeckWildDeckItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForHSDeckFormat:HSDeckFormatWild]
                                                                       action:nil
                                                                keyEquivalent:@""];
    createNewDeckWildDeckItem.identifier = NSUserInterfaceItemIdentifierDecksCreateNewWildDeck;
    
    NSMenuItem *createNewDeckClassicDeckItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForHSDeckFormat:HSDeckFormatClassic]
                                                                          action:nil
                                                                   keyEquivalent:@""];
    createNewDeckClassicDeckItem.identifier = NSUserInterfaceItemIdentifierDecksCreateNewClassicDeck;
    
    NSMenuItem *createNewDeckFromDeckCodeItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyLoadFromDeckCode] action:@selector(createNewDeckFromDeckCodeItemTriggered:) keyEquivalent:@""];
    createNewDeckFromDeckCodeItem.target = self;
    createNewDeckFromDeckCodeItem.identifier = NSUserInterfaceItemIdentifierDecksCreateNewDeckFromDeckCode;
    
    createDeckMenu.itemArray = @[createNewDeckStandardDeckItem, createNewDeckWildDeckItem, createNewDeckClassicDeckItem, createNewDeckFromDeckCodeItem];
    
    //
    
    [createDeckMenuItem release];
    [createDeckMenu release];
    
    self.createNewDeckStandardDeckItem = createNewDeckStandardDeckItem;
    self.createNewDeckWildDeckItem = createNewDeckWildDeckItem;
    self.createNewDeckClassicDeckItem = createNewDeckClassicDeckItem;
    self.createNewDeckFromDeckCodeItem = createNewDeckFromDeckCodeItem;
    
    [createNewDeckStandardDeckItem release];
    [createNewDeckWildDeckItem release];
    [createNewDeckClassicDeckItem release];
    [createNewDeckFromDeckCodeItem release];
}

- (void)keyMenuItemTriggered:(StorableMenuItem *)sender {
    HSDeckFormat hsDeckFormat = sender.userInfo.allKeys.firstObject;
    NSString *classSlug = sender.userInfo.allValues.firstObject;
    
    [self.decksMenuDelegate decksMenu:self createNewDeckWithDeckFormat:hsDeckFormat classSlug:classSlug];
}

- (void)createNewDeckFromDeckCodeItemTriggered:(NSMenuItem *)sender {
    [self.decksMenuDelegate decksMenu:self createNewDeckFromDeckCodeWithIdentifier:sender.identifier];
}

@end
