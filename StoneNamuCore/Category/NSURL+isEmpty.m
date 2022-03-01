//
//  NSURL+isEmpty.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 3/2/22.
//

#import <StoneNamuCore/NSURL+isEmpty.h>

@implementation NSURL (isEmpty)

- (BOOL)isEmpty {
    NSString * _Nullable absoluteString = self.absoluteString;
    
    if ((absoluteString) && (![absoluteString isEqualToString:@""])) {
        return NO;
    } else {
        return YES;
    }
}

@end
