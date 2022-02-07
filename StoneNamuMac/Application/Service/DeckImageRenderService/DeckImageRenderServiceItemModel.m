//
//  DeckImageRenderServiceItemModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import "DeckImageRenderServiceItemModel.h"

@implementation DeckImageRenderServiceItemModel

- (instancetype)initWithType:(DeckImageRenderServiceItemModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
        self.classSlug = nil;
        self.className = nil;
        self.totalArcaneDust = nil;
        self.deckName = nil;
        self.raritySlug = nil;
        self.isEasterEgg = NO;
        self.deckFormat = nil;
        self.hsCard = nil;
        self.hsCardImage = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_classSlug release];
    [_className release];
    [_totalArcaneDust release];
    [_deckName release];
    [_raritySlug release];
    [_hsYearCurrentName release];
    [_deckFormat release];
    [_hsCard release];
    [_hsCardImage release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    DeckImageRenderServiceItemModel *toCompare = (DeckImageRenderServiceItemModel *)object;
    
    if (![toCompare isKindOfClass:[DeckImageRenderServiceItemModel class]]) {
        return NO;
    }
    
    BOOL type = (self.type == toCompare.type);
    BOOL classSlug = compareNullableValues(self.classSlug, toCompare.classSlug, @selector(isEqualToString:));
    BOOL className = compareNullableValues(self.className, toCompare.className, @selector(isEqualToString:));
    BOOL totalArcaneDust = compareNullableValues(self.totalArcaneDust, toCompare.totalArcaneDust, @selector(isEqualToNumber:));
    BOOL raritySlug = compareNullableValues(self.raritySlug, toCompare.raritySlug, @selector(isEqualToString:));
    BOOL deckName = compareNullableValues(self.deckName, toCompare.deckName, @selector(isEqualToString:));
    BOOL isEasterEgg = (self.isEasterEgg == toCompare.isEasterEgg);
    BOOL deckFormat = compareNullableValues(self.deckFormat, toCompare.deckFormat, @selector(isEqualToString:));
    BOOL hsCard = compareNullableValues(self.hsCard, toCompare.hsCard, @selector(isEqual:));
    
    return (type && classSlug && className && totalArcaneDust && raritySlug && deckName && isEasterEgg && deckFormat && hsCard);
}

- (NSUInteger)hash {
    return self.type ^ self.classSlug.hash ^ self.className.hash ^ self.totalArcaneDust.hash ^ self.deckName.hash ^ self.isEasterEgg ^ self.deckFormat.hash ^ self.hsCard.hash;
}

@end
