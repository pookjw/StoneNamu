//
//  DeckDetailsManaCostContentSectionModel.m
//  DeckDetailsManaCostContentSectionModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckDetailsManaCostContentSectionModel.h"

@implementation DeckDetailsManaCostContentSectionModel

- (instancetype)initWithType:(DeckDetailsManaCostContentSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    DeckDetailsManaCostContentSectionModel *toCompare = (DeckDetailsManaCostContentSectionModel *)object;
    
    if (![toCompare isKindOfClass:[DeckDetailsManaCostContentSectionModel class]]) {
        return NO;
    }
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

@end
