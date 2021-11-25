//
//  NSTouchBarItemIdentifierDecks+HSDeckFormat.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

static NSTouchBarItemIdentifier const NSTouchBarItemIdentifierDecksCreateNewStandardDeck = @"NSTouchBarItemIdentifierDecksCreateNewStandardDeck";
static NSTouchBarItemIdentifier const NSTouchBarItemIdentifierDecksCreateNewWildDeck = @"NSTouchBarItemIdentifierDecksCreateNewWildDeck";
static NSTouchBarItemIdentifier const NSTouchBarItemIdentifierDecksCreateNewClassicDeck = @"NSTouchBarItemIdentifierDecksCreateNewClassicDeck";
static NSTouchBarItemIdentifier const NSTouchBarItemIdentifierDecksCreateNewDeckFromDeckCode = @"NSTouchBarItemIdentifierDecksCreateNewDeckFromDeckCode";

NSArray<NSTouchBarItemIdentifier> * allNSTouchBarItemIdentifierDecks(void);
NSTouchBarItemIdentifier NSTouchBarItemIdentifierDecksFromHSDeckFormat(HSDeckFormat deckFormat);
HSDeckFormat HSDeckFormatFromNSTouchBarItemIdentifierDecks(NSTouchBarItemIdentifier itemIdentifiers);
