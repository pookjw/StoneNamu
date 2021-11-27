//
//  NSUserInterfaceItemIdentifierDecks+HSDeckFormat.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/27/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDecksCreateNewStandardDeck = @"NSUserInterfaceItemIdentifierCreateNewStandardDeck";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDecksCreateNewWildDeck = @"NSUserInterfaceItemIdentifierDecksCreateNewWildDeck";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDecksCreateNewClassicDeck = @"NSUserInterfaceItemIdentifierDecksCreateNewClassicDeck";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDecksCreateNewDeckFromDeckCode = @"NSUserInterfaceItemIdentifierDecksCreateNewDeckFromDeckCode";

NSArray<NSUserInterfaceItemIdentifier> * allNSUserInterfaceItemIdentifierDecks(void);
NSUserInterfaceItemIdentifier NSUserInterfaceItemIdentifierDecksFromHSDeckFormat(HSDeckFormat deckFormat);
HSDeckFormat HSDeckFormatFromNSUserInterfaceItemIdentifierDecks(NSUserInterfaceItemIdentifier itemIdentifier);
