//
//  NSToolbarIdentifierDecks+HSDeckFormat.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

static NSToolbarIdentifier const NSToolbarIdentifierDecksCreateNewStandardDeck = @"NSToolbarIdentifierDecksCreateNewStandardDeck";
static NSToolbarIdentifier const NSToolbarIdentifierDecksCreateNewWildDeck = @"NSToolbarIdentifierDecksCreateNewWildDeck";
static NSToolbarIdentifier const NSToolbarIdentifierDecksCreateNewClassicDeck = @"NSToolbarIdentifierDecksCreateNewClassicDeck";
static NSToolbarIdentifier const NSToolbarIdentifierDecksCreateNewDeckFromDeckCode = @"NSToolbarIdentifierDecksCreateNewDeckFromDeckCode";

NSArray<NSToolbarIdentifier> * allNSToolbarIdentifierDecks(void);
NSToolbarIdentifier NSToolbarIdentifierDecksFromHSDeckFormat(HSDeckFormat deckFormat);
HSDeckFormat HSDeckFormatFromNSToolbarIdentifierDecks(NSToolbarIdentifier itemIdentifier);
