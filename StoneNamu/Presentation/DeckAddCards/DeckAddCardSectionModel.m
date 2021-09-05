//
//  DeckAddCardSectionModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "DeckAddCardSectionModel.h"

@implementation DeckAddCardSectionModel

- (instancetype)initWithType:(DeckAddCardsSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[DeckAddCardSectionModel class]]) {
        return NO;
    }
    
    DeckAddCardSectionModel *toCompare = (DeckAddCardSectionModel *)object;
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

@end
