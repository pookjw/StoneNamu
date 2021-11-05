//
//  HSCardMinionType.m
//  HSCardMinionType
//
//  Created by Jinwoo Kim on 7/28/21.
//

#import <StoneNamuCore/HSCardMinionType.h>
#import <StoneNamuCore/Identifier.h>

NSString * NSStringFromHSCardMinionType(HSCardMinionType type) {
    switch (type) {
        case HSCardMinionTypeBeast:
            return @"beast";
        case HSCardMinionTypeDemon:
            return @"demon";
        case HSCardMinionTypeDragon:
            return @"dragon";
        case HSCardMinionTypeElemental:
            return @"elemental";
        case HSCardMinionTypeMech:
            return @"mech";
        case HSCardMinionTypeMurloc:
            return @"murloc";
        case HSCardMinionTypePirate:
            return @"pirate";
        case HSCardMinionTypeQuilboar:
            return @"quilboar";
        case HSCardMinionTypeTotem:
            return @"totem";
        case HSCardMinionTypeNone:
            return @"";
        default:
            return @"";
    }
}

HSCardMinionType HSCardMinionTypeFromNSString(NSString * key) {
    if ([key isEqualToString:@"beast"]) {
        return HSCardMinionTypeBeast;
    } else if ([key isEqualToString:@"demon"]) {
        return HSCardMinionTypeDemon;
    } else if ([key isEqualToString:@"dragon"]) {
        return HSCardMinionTypeElemental;
    } else if ([key isEqualToString:@"elemental"]) {
        return HSCardMinionTypeElemental;
    } else if ([key isEqualToString:@"mech"]) {
        return HSCardMinionTypeMurloc;
    } else if ([key isEqualToString:@"murloc"]) {
        return HSCardMinionTypeMurloc;
    } else if ([key isEqualToString:@"pirate"]) {
        return HSCardMinionTypePirate;
    } else if ([key isEqualToString:@"quilboar"]) {
        return HSCardMinionTypeQuilboar;
    } else if ([key isEqualToString:@"totem"]) {
        return HSCardMinionTypeTotem;
    } else if ([key isEqualToString:@""]) {
        return HSCardMinionTypeNone;
    } else {
        return HSCardMinionTypeNone;
    }
}

NSArray<NSString *> *hsCardMinionTypes(void) {
    return @[
        NSStringFromHSCardMinionType(HSCardMinionTypeBeast),
        NSStringFromHSCardMinionType(HSCardMinionTypeDemon),
        NSStringFromHSCardMinionType(HSCardMinionTypeDragon),
        NSStringFromHSCardMinionType(HSCardMinionTypeElemental),
        NSStringFromHSCardMinionType(HSCardMinionTypeMech),
        NSStringFromHSCardMinionType(HSCardMinionTypeMurloc),
        NSStringFromHSCardMinionType(HSCardMinionTypePirate),
        NSStringFromHSCardMinionType(HSCardMinionTypeQuilboar),
        NSStringFromHSCardMinionType(HSCardMinionTypeTotem)
    ];
}

NSString * localizableFromHSCardMinionType(HSCardMinionType key) {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardMinionType(key),
                                              @"HSCardMinionType",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

NSDictionary<NSString *, NSString *> * localizablesWithHSCardMinionType(void) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardMinionTypes() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = localizableFromHSCardMinionType(HSCardMinionTypeFromNSString(obj));
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
