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
        return @"";
    }
}

HSDeckFormat HSDeckFormatFromNSTouchBarItemIdentifierDecks(NSTouchBarItemIdentifier itemIdentifiers) {
    if ([itemIdentifiers isEqualToString:NSTouchBarItemIdentifierDecksCreateNewStandardDeck]) {
        return HSDeckFormatStandard;
    } else if ([itemIdentifiers isEqualToString:NSTouchBarItemIdentifierDecksCreateNewWildDeck]) {
        return HSDeckFormatWild;
    } else if ([itemIdentifiers isEqualToString:NSTouchBarItemIdentifierDecksCreateNewClassicDeck]) {
        return HSDeckFormatClassic;
    } else {
        return @"";
    }
}
