//
//  NSNumber+sepearatedDecimalNumber.m
//  NSNumber+sepearatedDecimalNumber
//
//  Created by Jinwoo Kim on 9/15/21.
//

#import "NSNumber+stringWithSepearatedDecimalNumber.h"

@implementation NSNumber (stringWithSepearatedDecimalNumber)

- (NSString *)stringWithSepearatedDecimalNumber {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.groupingSeparator = @",";
    NSString *formatted = [formatter stringFromNumber:self];
    [formatter release];
    return formatted;
}

@end

