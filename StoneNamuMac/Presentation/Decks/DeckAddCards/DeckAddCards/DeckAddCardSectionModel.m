//
//  DeckAddCardSectionModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/8/21.
//

#import "DeckAddCardSectionModel.h"

@implementation DeckAddCardSectionModel

- (instancetype)initWithType:(DeckAddCardSectionModelType)type {
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
