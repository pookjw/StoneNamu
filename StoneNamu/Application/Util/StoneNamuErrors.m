//
//  StoneNamuErrors.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 10/23/21.
//

#import "StoneNamuErrors.h"
#import <StoneNamuResources/StoneNamuResources.h>

NSError * DataCorruptionError(void) {
    return [NSError errorWithDomain:@"com.pookjw.StoneNamu.DataCorruptionError"
                               code:100
                           userInfo:@{NSLocalizedDescriptionKey: [ResourcesService localizaedStringForKey:LocalizableKeyDataIsCorrupted]}];
}
