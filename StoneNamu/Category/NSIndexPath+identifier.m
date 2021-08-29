//
//  NSIndexPath+identifier.m
//  NSIndexPath+identifier
//
//  Created by Jinwoo Kim on 8/29/21.
//

#import "NSIndexPath+identifier.h"
#define NSINDEXPATH_STRING_IDENTIFIER @"NSINDEXPATH_STRING_IDENTIFIER"

@implementation NSIndexPath (identifier)

- (NSString *)identifier {
    return [NSString stringWithFormat:@"%@^%ld^%ld", NSINDEXPATH_STRING_IDENTIFIER, self.section, self.row];
}

+ (instancetype)indexPathFromString:(NSString *)string {
    NSArray<NSString *> *components = [string componentsSeparatedByString:@"^"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSInteger section = [[formatter numberFromString:components[1]] integerValue];
    NSInteger row = [[formatter numberFromString:components[2]] integerValue];
    
    [formatter release];
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

@end
