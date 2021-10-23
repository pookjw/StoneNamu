//
//  HSCard.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "HSCard.h"
#import <StoneNamuCore/StoneNamuCoreErrors.h>

@implementation HSCard

- (void)dealloc {
    [_slug release];
    [_multiClassIds release];
    [_artistName release];
    [_name release];
    [_text release];
    [_image release];
    [_imageGold release];
    [_flavorText release];
    [_cropImage release];
    [_childIds release];
    [_gameModes release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[HSCard class]]) {
        return NO;
    }
    
    HSCard *toCompare = (HSCard *)object;
    
    return (self.cardId == toCompare.cardId) && ([self.slug isEqualToString:toCompare.slug]);
}

- (NSComparisonResult)compare:(HSCard *)other {
    if (self.manaCost < other.manaCost) {
        return NSOrderedAscending;
    } else if (self.manaCost > other.manaCost) {
        return NSOrderedDescending;
    } else {
        if ((self.name == nil) && (other.name == nil)) {
            return NSOrderedSame;
        } else if ((self.name == nil) && (other.name != nil)) {
            return NSOrderedAscending;
        } else if ((self.name != nil) && (other.name == nil)) {
            return NSOrderedDescending;
        } else {
            return [self.name compare:other.name];
        }
    }
}

- (NSUInteger)hash {
    return self.cardId ^ self.slug.hash;
}

+ (NSArray<HSCard *> *)hsCardsFromDic:(NSDictionary *)dic {
    NSArray *cards = dic[@"cards"];
    NSMutableArray *hsCards = [[@[] mutableCopy] autorelease];
    
    for (NSDictionary *card in cards) {
        @autoreleasepool {
            HSCard *hsCard = [HSCard hsCardFromDic:card error:nil];
            if (hsCard) {
                [hsCards addObject:hsCard];
            }
        }
    }
    
    return hsCards;
}

+ (HSCard * _Nullable)hsCardFromDic:(NSDictionary *)dic error:(NSError ** _Nullable)error; {
    HSCard *hsCard = [HSCard new];
    
    if (dic[@"id"] == nil) {
        if (error) {
            *error = InvalidHSCardError();
        }
        [hsCard release];
        return nil;
    }
    
    hsCard->_cardId = [(NSNumber *)dic[@"id"] unsignedIntegerValue];
    hsCard->_collectible = [(NSNumber *)dic[@"collectible"] boolValue];
    hsCard->_slug = [dic[@"slug"] copy];
    
    id classId = dic[@"classId"];
    if ([classId isEqual:[NSNull null]]) {
        hsCard->_classId = HSCardClassNeutral;
    } else {
        hsCard->_classId = [(NSNumber *)classId unsignedIntegerValue];
    }
    
    id multiClassIds = dic[@"multiClassIds"];
    if ([multiClassIds isEqual:[NSNull null]]) {
        hsCard->_multiClassIds = nil;
    } else {
        hsCard->_multiClassIds = [dic[@"multiClassIds"] copy];
    }
    
    hsCard->_minionTypeId = [(NSNumber *)dic[@"minionTypeId"] unsignedIntegerValue];
    hsCard->_cardTypeId = [(NSNumber *)dic[@"cardTypeId"] unsignedIntegerValue];
    hsCard->_cardSetId = [(NSNumber *)dic[@"cardSetId"] unsignedIntegerValue];
    
    id rarityId = dic[@"rarityId"];
    if ([rarityId isEqual:[NSNull null]]) {
        hsCard->_rarityId = HSCardRarityNull;
    } else {
        hsCard->_rarityId = [(NSNumber *)rarityId unsignedIntegerValue];
    }
    
    id artistName = dic[@"artistName"];
    if ([artistName isEqual:[NSNull null]] || ([(NSString *)artistName isEqualToString:@""])) {
        hsCard->_artistName = nil;
    } else {
        hsCard->_artistName = [artistName copy];
    }
    
    hsCard->_health = [(NSNumber *)dic[@"health"] unsignedIntegerValue];
    hsCard->_attack = [(NSNumber *)dic[@"attack"] unsignedIntegerValue];
    hsCard->_manaCost = [(NSNumber *)dic[@"manaCost"] unsignedIntegerValue];
    
    id name = dic[@"name"];
    if ([name isEqual:[NSNull null]]) {
        hsCard->_name = nil;
    } else {
        hsCard->_name = [name copy];
    }
    
    hsCard->_text = [dic[@"text"] copy];
    hsCard->_image = [[NSURL URLWithString:dic[@"image"]] copy];
    
    if ([dic[@"imageGold"] isKindOfClass:[NSString class]] && [(NSString *)dic[@"imageGold"] isEqualToString:@""]) {
        hsCard->_imageGold = nil;
    } else {
        hsCard->_imageGold = [[NSURL URLWithString:dic[@"imageGold"]] copy];
    }

    hsCard->_flavorText = [dic[@"flavorText"] copy];
    
    id cropImage = dic[@"cropImage"];
    if ([cropImage isEqual:[NSNull null]]) {
        hsCard->_cropImage = nil;
    } else {
        hsCard->_cropImage = [[NSURL URLWithString:(NSString *)cropImage] copy];
    }

    hsCard->_childIds = [dic[@"childIds"] copy];
    
    // Game Modes
    NSMutableArray<NSNumber *> *gameModes = [@[] mutableCopy];
    NSDictionary *battlegrounds = dic[@"battlegrounds"];
    NSDictionary *duels = dic[@"duels"];
    
    if (battlegrounds.count > 0) {
        [gameModes addObject:[NSNumber numberWithUnsignedInteger:HSCardGameModeBattlegrounds]];
    } else if (duels.count > 0) {
        if ([(NSNumber *)duels[@"relevant"] boolValue]) {
            [gameModes addObject:[NSNumber numberWithUnsignedInteger:HSCardGameModeDuels]];
        }
        if ([(NSNumber *)duels[@"constructed"] boolValue]) {
            [gameModes addObject:[NSNumber numberWithUnsignedInteger:HSCardGameModeConstructed]];
        }
    }
    
    if (gameModes.count == 0) {
        [gameModes addObject:[NSNumber numberWithUnsignedInteger:HSCardGameModeConstructed]];
    }
    
    hsCard->_gameModes = [gameModes copy];
    [gameModes release];
    
    //
    
    if (dic[@"parentId"]) {
        hsCard->_parentId = [(NSNumber *)dic[@"parentId"] unsignedIntegerValue];
    } else {
        hsCard->_parentId = 0;
    }
    
    //
    
    return [hsCard autorelease];
}

+ (NSSet<Class> *)unarchvingClasses {
    NSSet *objectClasses = [NSSet setWithArray:@[NSNumber.class, NSArray.class, NSString.class, NSURL.class, HSCard.class]];
    return objectClasses;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCard *_copy = (HSCard *)copy;
        _copy->_cardId = self->_cardId;
        _copy->_collectible = self->_collectible;
        _copy->_slug = [self->_slug copyWithZone:zone];
        _copy->_classId = self->_classId;
        _copy->_multiClassIds = [self->_multiClassIds copyWithZone:zone];
        _copy->_minionTypeId = self->_minionTypeId;
        _copy->_cardTypeId = self->_cardTypeId;
        _copy->_cardSetId = self->_cardSetId;
        _copy->_rarityId = self->_rarityId;
        _copy->_artistName = [self->_artistName copyWithZone:zone];
        _copy->_health = self->_health;
        _copy->_attack = self->_attack;
        _copy->_manaCost = self->_manaCost;
        _copy->_name = [self->_name copyWithZone:zone];
        _copy->_text = [self->_text copyWithZone:zone];
        _copy->_image = [self->_image copyWithZone:zone];
        _copy->_imageGold = [self->_imageGold copyWithZone:zone];
        _copy->_flavorText = [self->_flavorText copyWithZone:zone];
        _copy->_cropImage = [self->_cropImage copyWithZone:zone];
        _copy->_childIds = [self->_childIds copyWithZone:zone];
        _copy->_gameModes = [self->_gameModes copyWithZone:zone];
        _copy->_parentId = self->_parentId;
    }
    
    return copy;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
    id object = [self init];
    
    if (object) {
        HSCard *cardObject = (HSCard *)object;
        cardObject->_cardId = [coder decodeIntegerForKey:@"cardId"];
        cardObject->_collectible = [coder decodeIntegerForKey:@"collectible"];
        cardObject->_slug = [[coder decodeObjectOfClass:[NSString class] forKey:@"slug"] copy];
        cardObject->_classId = [coder decodeIntegerForKey:@"classId"];
        cardObject->_multiClassIds = [[coder decodeObjectOfClass:[NSArray<NSNumber *> class] forKey:@"multiClassIds"] copy];
        cardObject->_minionTypeId = [coder decodeIntegerForKey:@"minionTypeId"];
        cardObject->_cardTypeId = [coder decodeIntegerForKey:@"cardTypeId"];
        cardObject->_cardSetId = [coder decodeIntegerForKey:@"cardSetId"];
        cardObject->_rarityId = [coder decodeIntegerForKey:@"rarityId"];
        cardObject->_artistName = [[coder decodeObjectOfClass:[NSString class] forKey:@"artistName"] copy];
        cardObject->_health = [coder decodeIntegerForKey:@"health"];
        cardObject->_attack = [coder decodeIntegerForKey:@"attack"];
        cardObject->_manaCost = [coder decodeIntegerForKey:@"manaCost"];
        cardObject->_name = [[coder decodeObjectOfClass:[NSString class] forKey:@"name"] copy];
        cardObject->_text = [[coder decodeObjectOfClass:[NSString class] forKey:@"text"] copy];
        cardObject->_image = [[coder decodeObjectOfClass:[NSURL class] forKey:@"image"] copy];
        cardObject->_imageGold = [[coder decodeObjectOfClass:[NSURL class] forKey:@"imageGold"] copy];
        cardObject->_flavorText = [[coder decodeObjectOfClass:[NSString class] forKey:@"flavorText"] copy];
        cardObject->_cropImage = [[coder decodeObjectOfClass:[NSURL class] forKey:@"cropImage"] copy];
        cardObject->_childIds = [[coder decodeObjectOfClass:[NSArray<NSNumber *> class] forKey:@"childIds"] copy];
        cardObject->_gameModes = [[coder decodeObjectOfClass:[NSArray<NSNumber *> class] forKey:@"gameModes"] copy];
        cardObject->_parentId = [coder decodeIntegerForKey:@"parentId"];
    }
    
    return object;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.cardId forKey:@"cardId"];
    [coder encodeInteger:self.collectible forKey:@"collectible"];
    [coder encodeObject:self.slug forKey:@"slug"];
    [coder encodeInteger:self.classId forKey:@"classId"];
    [coder encodeObject:self.multiClassIds forKey:@"multiClassIds"];
    [coder encodeInteger:self.minionTypeId forKey:@"minionTypeId"];
    [coder encodeInteger:self.cardTypeId forKey:@"cardTypeId"];
    [coder encodeInteger:self.cardSetId forKey:@"cardSetId"];
    [coder encodeInteger:self.rarityId forKey:@"rarityId"];
    [coder encodeObject:self.artistName forKey:@"artistName"];
    [coder encodeInteger:self.health forKey:@"health"];
    [coder encodeInteger:self.attack forKey:@"attack"];
    [coder encodeInteger:self.manaCost forKey:@"manaCost"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.text forKey:@"text"];
    [coder encodeObject:self.image forKey:@"image"];
    [coder encodeObject:self.imageGold forKey:@"imageGold"];
    [coder encodeObject:self.flavorText forKey:@"flavorText"];
    [coder encodeObject:self.cropImage forKey:@"cropImage"];
    [coder encodeObject:self.childIds forKey:@"childIds"];
    [coder encodeObject:self.gameModes forKey:@"gameModes"];
    [coder encodeInteger:self.parentId forKey:@"parentId"];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - NSItemProviderWriting

- (nullable NSProgress *)loadDataWithTypeIdentifier:(nonnull NSString *)typeIdentifier forItemProviderCompletionHandler:(nonnull void (^)(NSData * _Nullable, NSError * _Nullable))completionHandler {
    NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
    queue.qualityOfService = NSQualityOfServiceUserInitiated;
    [queue addOperationWithBlock:^{
        NSError * _Nullable error = nil;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:YES error:&error];
        completionHandler(data, error);
    }];
    
    return nil;
}

+ (NSArray<NSString *> *)writableTypeIdentifiersForItemProvider {
    return @[kHSCardType];
}

- (NSArray<NSString *> *)writableTypeIdentifiersForItemProvider {
    return @[kHSCardType];
}

#pragma mark - NSItemProviderReading

+ (instancetype)objectWithItemProviderData:(NSData *)data typeIdentifier:(NSString *)typeIdentifier error:(NSError * _Nullable *)outError {
    return [NSKeyedUnarchiver unarchivedObjectOfClasses:HSCard.unarchvingClasses fromData:data error:outError];
}

+ (NSArray<NSString *> *)readableTypeIdentifiersForItemProvider {
    return @[kHSCardType];
}

- (NSItemProviderRepresentationVisibility)itemProviderVisibilityForRepresentationWithTypeIdentifier:(NSString *)typeIdentifier {
    return NSItemProviderRepresentationVisibilityOwnProcess;
}

@end
