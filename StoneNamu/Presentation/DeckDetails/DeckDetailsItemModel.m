//
//  DeckDetailsItemModel.m
//  DeckDetailsItemModel
//
//  Created by Jinwoo Kim on 8/20/21.
//

#import "DeckDetailsItemModel.h"

@implementation DeckDetailsItemModel

- (instancetype)initWithType:(DeckDetailsItemModelType)type {
    self = [self init];
    
    if (self) {
        self->_hsCard = nil;
        self->_type = type;
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (NSUInteger)hash {
    return self.type ^ self.hsCard.hash;
}

@end
