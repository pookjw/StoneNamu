//
//  HSCardCollectible.m
//  HSCardCollectible
//
//  Created by Jinwoo Kim on 7/28/21.
//

#import <StoneNamuCore/HSCardCollectible.h>
#import <StoneNamuCore/Identifier.h>

NSString * NSStringFromHSCardCollectible(HSCardCollectible collectible) {
    switch (collectible) {
        case HSCardCollectibleYES:
            return @"1";
        case HSCardCollectibleNO:
            return @"0";
        default:
            return @"1";
    }
}

HSCardCollectible HSCardCollectibleFromNSString(NSString * key) {
    if ([key isEqualToString:@"1"]) {
        return HSCardCollectibleYES;
    } else if ([key isEqualToString:@"0"]) {
        return HSCardCollectibleNO;
    } else {
        return HSCardCollectibleYES;
    }
}

NSArray<NSString *> *hsCardCollectibles(void) {
    return @[
        NSStringFromHSCardCollectible(HSCardCollectibleYES),
        NSStringFromHSCardCollectible(HSCardCollectibleNO)
    ];
}

NSDictionary<NSString *, NSString *> * hsCardCollectiblesWithLocalizable(void) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardCollectibles() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        HSCardCollectible collectible = HSCardCollectibleFromNSString(obj);
        
        switch (collectible) {
            case HSCardCollectibleYES:
                dic[obj] = NSLocalizedStringFromTableInBundle(@"collectible_yes",
                                                              @"HSCardCollectible",
                                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                              @"");
                break;
            case HSCardCollectibleNO:
                dic[obj] = NSLocalizedStringFromTableInBundle(@"collectible_no",
                                                              @"HSCardCollectible",
                                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                              @"");
                break;
            default:
                break;
        }
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
