//
//  CardDetailsItemModel.m
//  CardDetailsItemModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import "CardDetailsItemModel.h"

@interface CardDetailsItemModel ()
@property (retain) NSString * _Nullable value;
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
            return NSLocalizedString(@"CARD_NAME", @"");
        case CardDetailsItemModelTypeFlavorText:
            return NSLocalizedString(@"CARD_FLAVOR_TEXT", @"");
        case CardDetailsItemModelTypeText:
            return NSLocalizedString(@"CARD_DESCRIPTION", @"");
        case CardDetailsItemModelTypeType:
            return NSLocalizedString(@"CARD_TYPE", @"");
        case CardDetailsItemModelTypeRarity:
            return NSLocalizedString(@"CARD_RARITY", @"");
        case CardDetailsItemModelTypeSet:
            return NSLocalizedString(@"CARD_SET", @"");
        case CardDetailsItemModelTypeClass:
            return NSLocalizedString(@"CARD_CLASS", @"");
        case CardDetailsItemModelTypeArtist:
            return NSLocalizedString(@"CARD_ARTIST", @"");
        case CardDetailsItemModelTypeCollectible:
            return NSLocalizedString(@"CARD_COLLECTIBLE", @"");
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
