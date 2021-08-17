//
//  LocalDeck.m
//  LocalDeck
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import "LocalDeck.h"

@implementation LocalDeck

@dynamic isWild;
@dynamic classId;
@dynamic deckCode;
@dynamic name;
@dynamic identity;

+ (NSString *)makeRandomIdentity {
    NSUUID *uuid = [NSUUID new];
    NSString *identity = [uuid.UUIDString copy];
    [uuid release];
    return [identity autorelease];
}

- (BOOL)isEqual:(id)object {
    LocalDeck *toCompare = (LocalDeck *)object;
    
    if (![toCompare isKindOfClass:[LocalDeck class]]) {
        return NO;
    }
    
    if ((self.identity == nil) && (toCompare.identity)) {
        NSLog(@"nil comparison!!!");
        return NO;
    }
    
    return [self.identity isEqualToString:toCompare.identity];
}

@end
