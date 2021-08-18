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
                                              @"");;
}


NSError * DataCorruptionError(void) {
    return [NSError errorWithDomain:@"com.pookjw.StoneNamuCore.DataCorruptionError"
                               code:100
                           userInfo:@{NSLocalizedDescriptionKey: LocalizedErrorString(@"DATA_IS_CORRUPTED")}];
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

