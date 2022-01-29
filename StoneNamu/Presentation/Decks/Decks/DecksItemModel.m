//
//  DecksItemModel.m
//  DecksItemModel
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import "DecksItemModel.h"

@implementation DecksItemModel

- (instancetype)initWithType:(DecksItemModelType)type localDeck:(LocalDeck *)localDeck isEasterEgg:(BOOL)isEasterEgg {
    self = [self init];
    
    if (self) {
        self->_type = type;
        [self->_localDeck release];
        self->_localDeck = [localDeck retain];
        self.isEasterEgg = isEasterEgg;
    }
    
    return self;
}

- (void)dealloc {
    [_localDeck release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    DecksItemModel *toCompare = (DecksItemModel *)object;
    
    if (![toCompare isKindOfClass:[DecksItemModel class]]) {
        return NO;
    }
    
    return (self.type == toCompare.type) &&
    ([self.localDeck isEqual:toCompare.localDeck]) &&
    (self.isEasterEgg == toCompare.isEasterEgg);
}

- (NSUInteger)hash {
    return self.type ^ self.isEasterEgg;
}

@end
