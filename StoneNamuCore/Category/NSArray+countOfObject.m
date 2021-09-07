//
//  NSArray+countOfObject.m
//  NSArray+countOfObject
//
//  Created by Jinwoo Kim on 9/6/21.
//

#import "NSArray+countOfObject.h"

@implementation NSArray (countOfObject)

- (NSUInteger)countOfObject:(id)object {
    NSUInteger count = 0;
    
    for (id tmp in self) {
        if ([tmp isEqual:object]) {
            count += 1;
        }
    }
    
    return count;
}

@end
