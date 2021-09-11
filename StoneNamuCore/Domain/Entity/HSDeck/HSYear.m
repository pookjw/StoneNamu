//
//  HSYear.m
//  HSYear
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "HSYear.h"

NSString * hsYearCurrent(void) {
    return @"year-of-the-gryphon";
}

NSArray<NSString *> * hsYears(void) {
    return @[
        HSYearGryphon
    ];
}

NSDictionary<NSString *, NSString *> *hsYearsWithLocalizables(void) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsYears() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = NSLocalizedStringFromTableInBundle(obj,
                                                      @"HSYear",
                                                      [NSBundle bundleWithIdentifier:@"com.pookjw.StoneNamuCore"],
                                                      @"");
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
