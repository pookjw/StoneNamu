//
//  StoneNamuErrors.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 10/23/21.
//

#import "StoneNamuErrors.h"

NSError * DataCorruptionError(void) {
    return [NSError errorWithDomain:@"com.pookjw.StoneNamu.DataCorruptionError"
                               code:100
                           userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"DATA_IS_CORRUPTED", @"")}];
}
