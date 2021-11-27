//
//  NSTouchBarItemIdentifierDecks+HSDeckFormat.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import "NSTouchBarItemIdentifierDecks+HSDeckFormat.h"

NSArray<NSTouchBarItemIdentifier> * allNSTouchBarItemIdentifierDecks(void) {
    return @[NSTouchBarItemIdentifierDecksCreateNewStandardDeck,
             NSTouchBarItemIdentifierDecksCreateNewWildDeck,
             NSTouchBarItemIdentifierDecksCreateNewClassicDeck,
             NSTouchBarItemIdentifierDecksCreateNewDeckFromDeckCode];
}

NSTouchBarItemIdentifier NSTouchBarItemIdentifierDecksFromHSDeckFormat(HSDeckFormat deckFormat) {
    if ([deckFormat isEqualToString:HSDeckFormatStandard]) {
        return NSTouchBarItemIdentifierDecksCreateNewStandardDeck;
    } else if ([deckFormat isEqualToString:HSDeckFormatWild]) {
        return NSTouchBarItemIdentifierDecksCreateNewWildDeck;
    } else if ([deckFormat isEqualToString:HSDeckFormatClassic]) {
        return NSTouchBarItemIdentifierDecksCreateNewClassicDeck;
    } else {
        return NSTouchBarItemIdentifierDecksCreateNewDeckFromDeckCode;
    }
}

HSDeckFormat HSDeckFormatFromNSTouchBarItemIdentifierDecks(NSTouchBarItemIdentifier itemIdentifier) {
    if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDecksCreateNewStandardDeck]) {
        return HSDeckFormatStandard;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDecksCreateNewWildDeck]) {
        return HSDeckFormatWild;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDecksCreateNewClassicDeck]) {
        return HSDeckFormatClassic;
    } else {
        return @"";
    }
}
