//
//  CardDetailsItemModel.m
//  CardDetailsItemModel
//
//  Created by Jinwoo Kim on 8/4/21.
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
        
        [self->_imageURL release];
        self->_imageURL = nil;
        
        self->_isGold = NO;
    }
    
    return self;
}

- (instancetype)initWithType:(CardDetailsItemModelType)type childHSCard:(HSCard *)childHSCard imageURL:(NSURL * _Nullable)imageURL isGold:(BOOL)isGold {
    self = [self init];
    
    if (self) {
        self->_type = type;
        
        self.value = nil;
        
        [self->_childHSCard release];
        self->_childHSCard = [childHSCard copy];
        
        [self->_imageURL release];
        self->_imageURL = [imageURL copy];
        
        self->_isGold = isGold;
    }
    
    return self;
}

- (void)dealloc {
    [_value release];
    [_childHSCard release];
    [_imageURL release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardDetailsItemModel class]]) {
        return NO;
    }
    
    CardDetailsItemModel *toCompare = (CardDetailsItemModel *)object;
    
    BOOL type = (self.type == toCompare.type);
    BOOL childHSCard = compareNullableValues(self.childHSCard, toCompare.childHSCard, @selector(isEqual:));
    BOOL imageURL = compareNullableValues(self.imageURL, toCompare.imageURL, @selector(isEqual:));
    
    return type && childHSCard && imageURL;
}

- (NSUInteger)hash {
    return self.type ^ self.childHSCard.hash ^ self.imageURL.hash;
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
