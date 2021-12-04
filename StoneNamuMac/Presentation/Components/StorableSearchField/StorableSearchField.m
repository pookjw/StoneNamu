//
//  StorableSearchField.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import "StorableSearchField.h"

@implementation StorableSearchField

- (instancetype)initWithUserInfo:(NSDictionary *)userInfo {
    self = [self init];
    
    if (self) {
        [self->_userInfo release];
        self->_userInfo = [userInfo copy];
    }
    
    return self;
}

- (void)dealloc {
    [_userInfo release];
    [super dealloc];
}

@end
