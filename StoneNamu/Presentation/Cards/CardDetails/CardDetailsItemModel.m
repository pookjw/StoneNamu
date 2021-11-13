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
        self->_childCards = nil;
    }
    
    return self;
}

- (instancetype)initWithType:(CardDetailsItemModelType)type childCards:(NSArray<HSCard *> *)childCards {
    self = [self init];
    
    if (self) {
        self->_type = type;
        self.value = nil;
        self->_childCards = [childCards copy];
    }
    
    return self;
}

- (void)dealloc {
    [_value release];
    [_childCards release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardDetailsItemModel class]]) {
        return NO;
    }
    
    CardDetailsItemModel *toCompare = (CardDetailsItemModel *)object;
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

- (NSString * _Nullable)primaryText {
    switch (self.type) {
        case CardDetailsItemModelTypeName:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardName];
        case CardDetailsItemModelTypeFlavorText:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardFlavorText];
        case CardDetailsItemModelTypeText:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardDescription];
        case CardDetailsItemModelTypeType:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardType];
        case CardDetailsItemModelTypeRarity:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardRarity];
        case CardDetailsItemModelTypeSet:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardSet];
        case CardDetailsItemModelTypeClass:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardClass];
        case CardDetailsItemModelTypeArtist:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardArtist];
        case CardDetailsItemModelTypeCollectible:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardCollectible];
        case CardDetailsItemModelTypeChildren:
            return nil;
        default:
            return nil;
    }
}

- (NSString * _Nullable)secondaryText {
    return self.value;
}

@end
