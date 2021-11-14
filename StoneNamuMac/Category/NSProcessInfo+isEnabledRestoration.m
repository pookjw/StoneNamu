//
//  NSProcessInfo+isEnabledRestoration.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/15/21.
//

#import "NSProcessInfo+isEnabledRestoration.h"
#import <StoneNamuCore/StoneNamuCore.h>

@implementation NSProcessInfo (isEnabledRestoration)

- (BOOL)isEnabledRestoration {
    return ![self.arguments containsString:@"-disableRestoration"];
}

@end
