//
//  DecksItemModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import "DecksItemModel.h"

@implementation DecksItemModel

- (instancetype)initWithType:(DecksItemModelType)type localDeck:(LocalDeck *)localDeck classSlug:(NSString *)classSlug isEasterEgg:(BOOL)isEasterEgg count:(NSUInteger)count {
    self = [self init];
    
    if (self) {
        self->_type = type;
        [self->_localDeck release];
        self->_localDeck = [localDeck retain];
        self.classSlug = classSlug;
        self.isEasterEgg = isEasterEgg;
        self.count = count;
    }
    
    return self;
}

- (void)dealloc {
    [_localDeck release];
    [_classSlug release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    DecksItemModel *toCompare = (DecksItemModel *)object;
    
    if (![toCompare isKindOfClass:[DecksItemModel class]]) {
        return NO;
    }
    
    return (self.type == toCompare.type) &&
    ([self.localDeck isEqual:toCompare.localDeck]);
}

- (NSUInteger)hash {
    return self.type ^ self.localDeck.hash;
}


@end
