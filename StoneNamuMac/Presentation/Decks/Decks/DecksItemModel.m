//
//  DecksItemModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import "DecksItemModel.h"

@implementation DecksItemModel

- (instancetype)initWithType:(DecksItemModelType)type localDeck:(LocalDeck *)localDeck classSlug:(NSString *)classSlug isEasterEgg:(BOOL)isEasterEgg name:(NSString *)name count:(NSUInteger)count maxCardsCount:(NSUInteger)maxCardsCount {
    self = [self init];
    
    if (self) {
        self->_type = type;
        
        [self->_localDeck release];
        self->_localDeck = [localDeck retain];
        
        self.classSlug = classSlug;
        self.isEasterEgg = isEasterEgg;
        self.name = name;
        self.count = count;
        self.maxCardsCount = maxCardsCount;
    }
    
    return self;
}

- (void)dealloc {
    [_localDeck release];
    [_classSlug release];
    [_name release];
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
