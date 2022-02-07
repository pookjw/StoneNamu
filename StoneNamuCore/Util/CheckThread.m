//
//  CheckThread.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/6/22.
//

#import <StoneNamuCore/CheckThread.h>

void checkThread(void) {
#if DEBUG
    if (NSThread.isMainThread) {
        NSString *message = @"Do not run at Main Thread.";
        [NSException raise:message format:@""];
    }
#endif
}
