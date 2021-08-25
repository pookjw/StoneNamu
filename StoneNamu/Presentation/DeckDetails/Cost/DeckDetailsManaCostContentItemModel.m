//
//  DeckDetailsManaCostContentItemModel.m
//  DeckDetailsManaCostContentItemModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckDetailsManaCostContentItemModel.h"

@implementation DeckDetailsManaCostContentItemModel

- (instancetype)initWithType:(DeckDetailsManaCostContentItemModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
        self.cardManaCost = nil;
        self.percentage = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_cardManaCost release];
    [_percentage release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    DeckDetailsManaCostContentItemModel *toCompare = (DeckDetailsManaCostContentItemModel *)object;
    
    if (![toCompare isKindOfClass:[DeckDetailsManaCostContentItemModel class]]) {
        return NO;
    }
    
    return (self.type == toCompare.type) &&
    (((self.cardManaCost == nil) && (toCompare.cardManaCost)) || ([self.cardManaCost isEqualToNumber:toCompare.cardManaCost])) &&
    (((self.percentage == nil) && (toCompare.percentage)) || ([self.percentage isEqualToNumber:toCompare.percentage]));
}

- (NSUInteger)hash {
    return self.type ^ self.cardManaCost.hash ^ self.percentage.hash;
}

@end
