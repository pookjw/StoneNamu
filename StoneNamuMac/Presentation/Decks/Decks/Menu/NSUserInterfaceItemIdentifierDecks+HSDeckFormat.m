//
//  NSUserInterfaceItemIdentifierDecks+HSDeckFormat.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/27/21.
//

#import "NSUserInterfaceItemIdentifierDecks+HSDeckFormat.h"

NSArray<NSUserInterfaceItemIdentifier> * allNSUserInterfaceItemIdentifierDecks(void) {
    return @[
        NSUserInterfaceItemIdentifierDecksCreateNewStandardDeck,
        NSUserInterfaceItemIdentifierDecksCreateNewWildDeck,
        NSUserInterfaceItemIdentifierDecksCreateNewClassicDeck,
        NSUserInterfaceItemIdentifierDecksCreateNewDeckFromDeckCode
    ];
}
NSUserInterfaceItemIdentifier NSUserInterfaceItemIdentifierDecksFromHSDeckFormat(HSDeckFormat deckFormat) {
    if ([deckFormat isEqualToString:HSDeckFormatStandard]) {
        return NSUserInterfaceItemIdentifierDecksCreateNewStandardDeck;
    } else if ([deckFormat isEqualToString:HSDeckFormatWild]) {
        return NSUserInterfaceItemIdentifierDecksCreateNewWildDeck;
    } else if ([deckFormat isEqualToString:HSDeckFormatClassic]) {
        return NSUserInterfaceItemIdentifierDecksCreateNewClassicDeck;
    } else {
        return NSUserInterfaceItemIdentifierDecksCreateNewDeckFromDeckCode;
    }
}

HSDeckFormat HSDeckFormatFromNSUserInterfaceItemIdentifierDecks(NSUserInterfaceItemIdentifier itemIdentifier) {
    if ([itemIdentifier isEqualToString:NSUserInterfaceItemIdentifierDecksCreateNewStandardDeck]) {
        return HSDeckFormatStandard;
    } else if ([itemIdentifier isEqualToString:NSUserInterfaceItemIdentifierDecksCreateNewWildDeck]) {
        return HSDeckFormatWild;
    } else if ([itemIdentifier isEqualToString:NSUserInterfaceItemIdentifierDecksCreateNewClassicDeck]) {
        return HSDeckFormatClassic;
    } else {
        return @"";
    }
}
