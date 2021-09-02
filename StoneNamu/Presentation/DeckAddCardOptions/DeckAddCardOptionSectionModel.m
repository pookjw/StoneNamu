//
//  DeckAddCardOptionSectionModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "DeckAddCardOptionSectionModel.h"

@implementation DeckAddCardOptionSectionModel

- (instancetype)initWithType:(DeckAddCardOptionSectionModelType)type {
    self = [self init];
    
    if (self) {
        _type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[DeckAddCardOptionSectionModel class]]) {
        return NO;
    }
    
    DeckAddCardOptionSectionModel *toCompare = (DeckAddCardOptionSectionModel *)object;
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

@end
