//
//  DeckImageRenderServiceItemModel.m
//  DeckImageRenderServiceItemModel
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import "DeckImageRenderServiceItemModel.h"

@implementation DeckImageRenderServiceItemModel

- (instancetype)initWithType:(DeckImageRenderServiceItemModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
        self.totalArcaneDust = nil;
        self.deckName = nil;
        self.isEasterEgg = NO;
        self.deckFormat = nil;
        self.hsCard = nil;
        self.hsCardImage = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_totalArcaneDust release];
    [_deckName release];
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
    
    //
    
    BOOL totalArcaneDust;
    
    if ((self.totalArcaneDust == nil) && (toCompare.totalArcaneDust == nil)) {
        totalArcaneDust = YES;
    } else if ((self.totalArcaneDust == nil) || (toCompare.totalArcaneDust == nil)) {
        totalArcaneDust = NO;
    } else {
        totalArcaneDust = [self.totalArcaneDust isEqualToNumber:toCompare.totalArcaneDust];
    }
    
    //
    
#warning 
    BOOL deckName = (((self.deckName == nil) && (toCompare.deckName == nil)) || ([self.deckName isEqualToString:toCompare.deckName]));
    BOOL isEasterEgg = (self.isEasterEgg == toCompare.isEasterEgg);
    BOOL classId = (self.classId == toCompare.classId);
    BOOL deckFormat = (((self.deckFormat == nil) && (toCompare.deckFormat == nil)) || ([self.deckFormat isEqualToString:toCompare.deckFormat]));
    BOOL hsCard = (((self.hsCard == nil) && (toCompare.hsCard == nil)) || ([self.hsCard isEqual:toCompare.hsCard]));
    
    return (type && totalArcaneDust && deckName && isEasterEgg && classId && deckFormat && hsCard);
}

- (NSUInteger)hash {
    return self.type ^ self.totalArcaneDust.hash ^ self.deckName.hash ^ self.isEasterEgg ^ self.classId ^ self.deckFormat.hash ^ self.hsCard.hash;
}

@end
