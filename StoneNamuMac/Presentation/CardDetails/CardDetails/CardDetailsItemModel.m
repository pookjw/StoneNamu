//
//  CardDetailsItemModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import "CardDetailsItemModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface CardDetailsItemModel ()
@property (copy) NSString * _Nullable value;
@end

@implementation CardDetailsItemModel

- (instancetype)initWithType:(CardDetailsItemModelType)type value:(NSString * _Nullable)value {
    self = [self init];
    
    if (self) {
        self->_type = type;
        self.value = value;
        [self->_childHSCard release];
        self->_childHSCard = nil;
    }
    
    return self;
}

- (instancetype)initWithType:(CardDetailsItemModelType)type childHSCard:(HSCard *)childHSCard {
    self = [self init];
    
    if (self) {
        self->_type = type;
        self.value = nil;
        [self->_childHSCard release];
        self->_childHSCard = [childHSCard copy];
    }
    
    return self;
}

- (void)dealloc {
    [_value release];
    [_childHSCard release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardDetailsItemModel class]]) {
        return NO;
    }
    
    CardDetailsItemModel *toCompare = (CardDetailsItemModel *)object;
    
    return self.type == toCompare.type &&
    ([self.childHSCard isEqual:toCompare.childHSCard] || ((self.childHSCard == nil) && (toCompare.childHSCard == nil)));
}

- (NSUInteger)hash {
    return self.type ^ self.childHSCard.hash;
}

- (NSString * _Nullable)primaryText {
    switch (self.type) {
        case CardDetailsItemModelTypeName:
            return [ResourcesService localizationForKey:LocalizableKeyCardName];
        case CardDetailsItemModelTypeFlavorText:
            return [ResourcesService localizationForKey:LocalizableKeyCardFlavorText];
        case CardDetailsItemModelTypeText:
            return [ResourcesService localizationForKey:LocalizableKeyCardDescription];
        case CardDetailsItemModelTypeType:
            return [ResourcesService localizationForKey:LocalizableKeyCardType];
        case CardDetailsItemModelTypeRarity:
            return [ResourcesService localizationForKey:LocalizableKeyCardRarity];
        case CardDetailsItemModelTypeSet:
            return [ResourcesService localizationForKey:LocalizableKeyCardSet];
        case CardDetailsItemModelTypeClass:
            return [ResourcesService localizationForKey:LocalizableKeyCardClass];
        case CardDetailsItemModelTypeArtist:
            return [ResourcesService localizationForKey:LocalizableKeyCardArtist];
        case CardDetailsItemModelTypeCollectible:
            return [ResourcesService localizationForKey:LocalizableKeyCardCollectible];
        case CardDetailsItemModelTypeChild:
            return nil;
        default:
            return nil;
    }
}

- (NSString * _Nullable)secondaryText {
    return self.value;
}

@end
