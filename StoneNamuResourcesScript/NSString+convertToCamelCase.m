//
//  NSString+convertToCamelCase.m
//  StoneNamuResourcesScript
//
//  Created by Jinwoo Kim on 11/12/21.
//

#import "NSString+convertToCamelCase.h"

@implementation NSString (convertToCamelCase)

- (NSString *)convertToCamelCase {
    NSArray<NSString *> *separated;
    
    if ([self containsString:@"_"]) {
        separated = [self componentsSeparatedByString:@"_"];
    } else {
        separated = [self componentsSeparatedByString:@"-"];
    }
    
    NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
    
    [separated enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[obj length]];

        [obj enumerateSubstringsInRange:NSMakeRange(0, obj.length)
                                      options:NSStringEnumerationByComposedCharacterSequences
                                   usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            [characters addObject:substring];
        }];
        
        for (NSUInteger idx = 0; idx<characters.count; idx++) {
            if (idx == 0) {
                [result appendString:[characters[idx] uppercaseString]];
            } else {
                [result appendString:[characters[idx] lowercaseString]];
            }
        }
    }];
    
    return [result autorelease];
}

@end
