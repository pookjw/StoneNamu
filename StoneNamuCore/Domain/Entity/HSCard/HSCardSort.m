//
//  HSCardSort.m
//  HSCardSort
//
//  Created by Jinwoo Kim on 7/29/21.
//

#import "HSCardSort.h"

NSString * NSStringFromHSCardSort(HSCardSort sort) {
    switch (sort) {
        case HSCardSortManaCostAsc:
            return @"manaCost:asc";
        case HSCardSortManaCostDesc:
            return @"manaCost:desc";
        case HSCardSortAttackAsc:
            return @"attack:asc";
        case HSCardSortAttackDesc:
            return @"attack:desc";
        case HSCardSortHealthAsc:
            return @"health:asc";
        case HSCardSortHealthDesc:
            return @"health:desc";
        case HSCardSortClassAsc:
            return @"class:asc";
        case HSCardSortClassDesc:
            return @"class:desc";
        case HSCardSortGroupByClassAsc:
            return @"groupByClass:asc";
        case HSCardSortGroupByClassDesc:
            return @"groupByClass:desc";
        case HSCardSortNameAsc:
            return @"name:asc";
        case HSCardSortNameDesc:
            return @"name:desc";
        default:
            return @"name:asc";
    }
}

HSCardSort HSCardSortFromNSString(NSString * key) {
    if ([key isEqualToString:@"manaCost:asc"]) {
        return HSCardSortManaCostAsc;
    } else if ([key isEqualToString:@"manaCost:desc"]) {
        return HSCardSortManaCostDesc;
    } else if ([key isEqualToString:@"attack:asc"]) {
        return HSCardSortAttackAsc;
    } else if ([key isEqualToString:@"attack:desc"]) {
        return HSCardSortAttackDesc;
    } else if ([key isEqualToString:@"health:asc"]) {
        return HSCardSortHealthAsc;
    } else if ([key isEqualToString:@"health:desc"]) {
        return HSCardSortHealthDesc;
    } else if ([key isEqualToString:@"class:asc"]) {
        return HSCardSortClassAsc;
    } else if ([key isEqualToString:@"class:desc"]) {
        return HSCardSortClassDesc;
    } else if ([key isEqualToString:@"groupByClass:asc"]) {
        return HSCardSortGroupByClassAsc;
    } else if ([key isEqualToString:@"groupByClass:desc"]) {
        return HSCardSortGroupByClassDesc;
    } else if ([key isEqualToString:@"name:asc"]) {
        return HSCardSortNameAsc;
    } else if ([key isEqualToString:@"name:desc"]) {
        return HSCardSortNameDesc;
    } else {
        return HSCardSortNameAsc;
    }
}

NSArray<NSString *> *hsCardSorts(void) {
    return @[
        NSStringFromHSCardSort(HSCardSortManaCostAsc),
        NSStringFromHSCardSort(HSCardSortManaCostDesc),
        NSStringFromHSCardSort(HSCardSortAttackAsc),
        NSStringFromHSCardSort(HSCardSortAttackDesc),
        NSStringFromHSCardSort(HSCardSortHealthAsc),
        NSStringFromHSCardSort(HSCardSortHealthDesc),
        NSStringFromHSCardSort(HSCardSortClassAsc),
        NSStringFromHSCardSort(HSCardSortClassDesc),
        NSStringFromHSCardSort(HSCardSortGroupByClassAsc),
        NSStringFromHSCardSort(HSCardSortGroupByClassDesc),
        NSStringFromHSCardSort(HSCardSortNameAsc),
        NSStringFromHSCardSort(HSCardSortNameDesc),
    ];
}

NSDictionary<NSString *, NSString *> * hsCardSortsWithLocalizable(void) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardSorts() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = NSLocalizedStringFromTableInBundle(obj,
                                                      @"HSCardSort",
                                                      [NSBundle bundleWithIdentifier:@"com.pookjw.StoneNamuCore"],
                                                      @"");
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
