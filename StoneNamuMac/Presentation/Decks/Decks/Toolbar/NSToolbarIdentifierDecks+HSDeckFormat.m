//
//  NSToolbarIdentifierDecks+HSDeckFormat.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import "NSToolbarIdentifierDecks+HSDeckFormat.h"

NSArray<NSToolbarIdentifier> * allNSToolbarIdentifierDecks(void) {
    return @[
        NSToolbarIdentifierDecksCreateNewStandardDeck,
        NSToolbarIdentifierDecksCreateNewWildDeck,
        NSToolbarIdentifierDecksCreateNewClassicDeck,
        NSToolbarIdentifierDecksCreateNewDeckFromDeckCode
    ];
}

NSToolbarIdentifier NSToolbarIdentifierDecksFromHSDeckFormat(HSDeckFormat deckFormat) {
    if ([deckFormat isEqualToString:HSDeckFormatStandard]) {
        return NSToolbarIdentifierDecksCreateNewStandardDeck;
    } else if ([deckFormat isEqualToString:HSDeckFormatWild]) {
        return NSToolbarIdentifierDecksCreateNewWildDeck;
    } else if ([deckFormat isEqualToString:HSDeckFormatClassic]) {
        return NSToolbarIdentifierDecksCreateNewClassicDeck;
    } else {
        return NSToolbarIdentifierDecksCreateNewDeckFromDeckCode;
    }
}

HSDeckFormat HSDeckFormatFromNSToolbarIdentifierDecks(NSToolbarIdentifier itemIdentifier) {
    if ([itemIdentifier isEqualToString:NSToolbarIdentifierDecksCreateNewStandardDeck]) {
        return HSDeckFormatStandard;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDecksCreateNewWildDeck]) {
        return HSDeckFormatWild;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDecksCreateNewClassicDeck]) {
        return HSDeckFormatClassic;
    } else {
        return @"";
    }
}
