//
//  compareNullableValues.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/8/22.
//

#import <StoneNamuCore/compareNullableValues.h>

BOOL compareNullableValues(id _Nullable lhs, id _Nullable rhs, SEL sel) {
    BOOL result;
    
    if ((lhs == nil) && (rhs == nil)) {
        result = YES;
    } else if ((lhs == nil) || (rhs == nil)) {
        result = NO;
    } else {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[lhs class] instanceMethodSignatureForSelector:sel]];
        invocation.selector = sel;
        invocation.target = lhs;
        [invocation setArgument:&rhs atIndex:2];
        [invocation invoke];
        [invocation getReturnValue:&result];
    }
    
    return result;
}

NSComparisonResult comparisonResultNullableValues(id _Nullable lhs, id _Nullable rhs, SEL sel) {
    NSComparisonResult result;
    
    if ((lhs == nil) && (rhs == nil)) {
        result = NSOrderedSame;
    } else if ((lhs == nil) || (rhs == nil)) {
        result = NSOrderedSame;
    } else {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[lhs class] instanceMethodSignatureForSelector:sel]];
        invocation.selector = sel;
        invocation.target = lhs;
        [invocation setArgument:&rhs atIndex:2];
        [invocation invoke];
        [invocation getReturnValue:&result];
    }
    
    return result;
}
