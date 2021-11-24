//
//  DecksSectionModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import "DecksSectionModel.h"

@implementation DecksSectionModel

- (instancetype)initWithType:(DecksSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    DecksSectionModel *toCompare = (DecksSectionModel *)object;
    
    if (![object isKindOfClass:[DecksSectionModel class]]) {
        return NO;
    }
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

@end
