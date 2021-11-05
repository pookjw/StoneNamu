//
//  NSString+arrayOfCharacters.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 9/20/21.
//

#import <StoneNamuCore/NSString+arrayOfCharacters.h>

@implementation NSString (arrayOfCharacters)

- (NSArray<NSString *> *)arrayOfCharacters {
    NSMutableArray<NSString *> *mutableArr = [@[] mutableCopy];
    
    for (NSUInteger i = 0; i < self.length; i++) {
        @autoreleasepool {
            NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
            [mutableArr addObject:str];
        }
    }
    
    NSArray<NSString *> *result = [mutableArr copy];
    [mutableArr release];
    
    return [result autorelease];
}

@end
