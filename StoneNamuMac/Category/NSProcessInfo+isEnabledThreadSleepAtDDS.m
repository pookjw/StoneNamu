//
//  NSProcessInfo+isEnabledThreadSleepAtDDS.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/8/22.
//

#import "NSProcessInfo+isEnabledThreadSleepAtDDS.h"
#import <StoneNamuCore/StoneNamuCore.h>

@implementation NSProcessInfo (isEnabledThreadSleepAtDDS)

- (BOOL)isEnabledThreadSleepAtDDS {
    return [self.arguments containsString:@"--enableThreadSleepAtDDS"];
}

@end
