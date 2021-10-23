//
//  StoneNamuCoreErrors.m
//  StoneNamuCoreErrors
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import "StoneNamuCoreErrors.h"

NSString * LocalizedErrorString(NSString *key) {
    return NSLocalizedStringFromTableInBundle(key,
                                              @"LocalizedError",
                                              [NSBundle bundleWithIdentifier:@"com.pookjw.StoneNamuCore"],
                                              @"");
}

NSError * InvalidHSCardError(void) {
    return [NSError errorWithDomain:@"com.pookjw.StoneNamuCore.InvalidHSCardError"
                               code:101
                           userInfo:@{NSLocalizedDescriptionKey: LocalizedErrorString(@"INVALID_HSCARD")}];
}

NSError * InvalidHSDeckError(void) {
    return [NSError errorWithDomain:@"com.pookjw.StoneNamuCore.InvalidHSDeckError"
                               code:102
                           userInfo:@{NSLocalizedDescriptionKey: LocalizedErrorString(@"INVALID_HSDECK")}];
}

NSError * CannotAddNoMoreThanThirtyCardsError(void) {
    return [NSError errorWithDomain:@"com.pookjw.StoneNamuCore.CannotAddNoMoreThanThirtyCardsError"
                               code:103
                           userInfo:@{NSLocalizedDescriptionKey: LocalizedErrorString(@"DECK_ADD_CARD_ERROR_NO_MORE_THAN_THIRTY_CARDS")}];
}

NSError * CannotAddDifferentClassCardError(void) {
    return [NSError errorWithDomain:@"com.pookjw.StoneNamuCore.CannotAddDifferentClassCardError"
                               code:104
                           userInfo:@{NSLocalizedDescriptionKey: LocalizedErrorString(@"DECK_ADD_CARD_ERROR_CANNOT_ADD_DIFFERENT_CLASS_CARD")}];
}

NSError * CannotAddNotCollectibleCardError(void) {
    return [NSError errorWithDomain:@"com.pookjw.StoneNamuCore.CannotAddNotCollectibleCardError"
                               code:105
                           userInfo:@{NSLocalizedDescriptionKey: LocalizedErrorString(@"DECK_ADD_CARD_ERROR_CANNOT_ADD_NOT_COLLECTIBLE_CARD")}];
}

NSError * CannotAddHeroPortraitCardError(void) {
    return [NSError errorWithDomain:@"com.pookjw.StoneNamuCore.CannotAddHeroPortraitCardError"
                               code:106
                           userInfo:@{NSLocalizedDescriptionKey: LocalizedErrorString(@"DECK_ADD_CARD_ERROR_CANNOT_ADD_HERO_PORTRAIT_CARD")}];
}

NSError * CannotAddSingleLegendaryCardMoreThanOneError(void) {
    return [NSError errorWithDomain:@"com.pookjw.StoneNamuCore.CannotAddSingleLegendaryCardMoreThanOneError"
                               code:107
                           userInfo:@{NSLocalizedDescriptionKey: LocalizedErrorString(@"DECK_ADD_CARD_ERROR_CANNOT_ADD_SINGLE_LAGENDARY_CARD_MORE_THAN_ONE")}];
}

NSError * CannotAddSingleCardMoreThanTwoError(void)  {
    return [NSError errorWithDomain:@"com.pookjw.StoneNamuCore.CannotAddSingleCardMoreThanTwoError"
                               code:108
                           userInfo:@{NSLocalizedDescriptionKey: LocalizedErrorString(@"DECK_ADD_CARD_ERROR_CANNOT_ADD_SINGLE_CARD_MORE_THAN_TWO")}];
}
