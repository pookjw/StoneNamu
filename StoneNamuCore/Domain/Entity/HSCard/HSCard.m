//
//  HSCard.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <StoneNamuCore/HSCard.h>
#import <StoneNamuCore/StoneNamuError.h>
#import <StoneNamuCore/compareNullableValues.h>

@implementation HSCard

- (void)dealloc {
    [_slug release];
    [_classId release];
    [_multiClassIds release];
    [_minionTypeId release];
    [_spellSchoolId release];
    [_cardTypeId release];
    [_cardSetId release];
    [_artistName release];
    [_rarityId release];
    [_name release];
    [_text release];
    [_image release];
    [_imageGold release];
    [_flavorText release];
    [_cropImage release];
    [_childIds release];
    [_battlegroundsHero release];
    [_battlegroundsTier release];
    [_battlegroundsUpgradeId release];
    [_battlegroundsImage release];
    [_battlegroundsImageGold release];
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
        NSComparisonResult result = comparisonResultNullableValues(self.name, other.name, @selector(compare:));
        
        switch (result) {
            case NSOrderedSame: {
                if (self.cardId < other.cardId) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedDescending;
                }
            }
            default:
                return result;
        }
    }
}

- (NSUInteger)hash {
    return self.cardId ^ self.slug.hash;
}

+ (NSArray<HSCard *> *)hsCardsFromDic:(NSDictionary *)dic {
    NSMutableArray<HSCard *> *hsCards = [NSMutableArray<HSCard *> new];
    
    [(NSArray<NSDictionary *> *)dic[@"cards"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HSCard *hsCard = [HSCard hsCardFromDic:obj error:nil];
        if (hsCard) {
            [hsCards addObject:hsCard];
        }
    }];
    
    return [hsCards autorelease];
}

+ (HSCard * _Nullable)hsCardFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error; {
    HSCard *hsCard = [HSCard new];
    
    if (dic[@"id"] == nil) {
        if (error) {
            *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeInvalidHSCard];
        }
        [hsCard release];
        return nil;
    }
    
    hsCard->_cardId = [(NSNumber *)dic[@"id"] unsignedIntegerValue];
    hsCard->_collectible = [(NSNumber *)dic[@"collectible"] boolValue];
    
    [hsCard->_slug release];
    hsCard->_slug = [dic[@"slug"] copy];
    
    id classId = dic[@"classId"];
    if ([classId isEqual:[NSNull null]]) {
        [hsCard->_classId release];
        hsCard->_classId = nil;
    } else {
        [hsCard->_classId release];
        hsCard->_classId = [classId copy];
    }
    
    id multiClassIds = dic[@"multiClassIds"];
    if ([multiClassIds isEqual:[NSNull null]]) {
        [hsCard->_multiClassIds release];
        hsCard->_multiClassIds = nil;
    } else {
        [hsCard->_multiClassIds release];
        hsCard->_multiClassIds = [dic[@"multiClassIds"] copy];
    }
    
    id minionTypeId = dic[@"minionTypeId"];
    if ([minionTypeId isEqual:[NSNull null]]) {
        [hsCard->_minionTypeId release];
        hsCard->_minionTypeId = nil;
    } else {
        [hsCard->_minionTypeId release];
        hsCard->_minionTypeId = [minionTypeId copy];
    }
    
    id spellSchoolId = dic[@"spellSchoolId"];
    if ([spellSchoolId isEqual:[NSNull null]]) {
        [hsCard->_spellSchoolId release];
        hsCard->_spellSchoolId = nil;
    } else {
        [hsCard->_spellSchoolId release];
        hsCard->_spellSchoolId = [spellSchoolId copy];
    }
    
    hsCard->_cardTypeId = [dic[@"cardTypeId"] copy];
    hsCard->_cardSetId = [dic[@"cardSetId"] copy];
    
    id rarityId = dic[@"rarityId"];
    if ([rarityId isEqual:[NSNull null]]) {
        [hsCard->_rarityId release];
        hsCard->_rarityId = nil;
    } else {
        [hsCard->_rarityId release];
        hsCard->_rarityId = [rarityId copy];
    }
    
    id artistName = dic[@"artistName"];
    if ([artistName isEqual:[NSNull null]] || ([(NSString *)artistName isEqualToString:@""])) {
        [hsCard->_artistName release];
        hsCard->_artistName = nil;
    } else {
        [hsCard->_artistName release];
        hsCard->_artistName = [artistName copy];
    }
    
    hsCard->_health = [(NSNumber *)dic[@"health"] unsignedIntegerValue];
    hsCard->_attack = [(NSNumber *)dic[@"attack"] unsignedIntegerValue];
    hsCard->_manaCost = [(NSNumber *)dic[@"manaCost"] unsignedIntegerValue];
    
    id name = dic[@"name"];
    if ([name isEqual:[NSNull null]]) {
        [hsCard->_name release];
        hsCard->_name = nil;
    } else {
        [hsCard->_name release];
        hsCard->_name = [name copy];
    }
    
    [hsCard->_text release];
    hsCard->_text = [dic[@"text"] copy];
    
    [hsCard->_image release];
    hsCard->_image = [[NSURL URLWithString:dic[@"image"]] copy];
    
    if ([dic[@"imageGold"] isKindOfClass:[NSString class]] && [(NSString *)dic[@"imageGold"] isEqualToString:@""]) {
        [hsCard->_imageGold release];
        hsCard->_imageGold = nil;
    } else {
        [hsCard->_imageGold release];
        hsCard->_imageGold = [[NSURL URLWithString:dic[@"imageGold"]] copy];
    }

    [hsCard->_flavorText release];
    hsCard->_flavorText = [dic[@"flavorText"] copy];
    
    id cropImage = dic[@"cropImage"];
    if ([cropImage isEqual:[NSNull null]]) {
        [hsCard->_cropImage release];
        hsCard->_cropImage = nil;
    } else {
        [hsCard->_cropImage release];
        hsCard->_cropImage = [[NSURL URLWithString:(NSString *)cropImage] copy];
    }

    [hsCard->_childIds release];
    hsCard->_childIds = [dic[@"childIds"] copy];
    
    //
    
    if (dic[@"parentId"]) {
        hsCard->_parentId = [(NSNumber *)dic[@"parentId"] unsignedIntegerValue];
    } else {
        hsCard->_parentId = 0;
    }
    
    //
    
    NSDictionary<NSString *, id> * _Nullable battlegrounds = dic[@"battlegrounds"];
    
    NSNumber * _Nullable battlegroundsTier = battlegrounds[@"tier"];
    [hsCard->_battlegroundsTier release];
    hsCard->_battlegroundsTier = [battlegroundsTier copy];
    
    NSNumber * _Nullable battlegroundsHero = battlegrounds[@"hero"];
    [hsCard->_battlegroundsHero release];
    hsCard->_battlegroundsHero = [battlegroundsHero copy];
    
    NSNumber * _Nullable battlegroundsUpgradeId = battlegrounds[@"upgradeId"];
    [hsCard->_battlegroundsUpgradeId release];
    hsCard->_battlegroundsUpgradeId = [battlegroundsUpgradeId copy];
    
    NSURL * _Nullable battlegroundsImage;
    if (battlegrounds[@"image"]) {
        battlegroundsImage = [NSURL URLWithString:battlegrounds[@"image"]];
    } else {
        battlegroundsImage = nil;
    }
    [hsCard->_battlegroundsImage release];
    hsCard->_battlegroundsImage = [battlegroundsImage copy];
    
    NSURL * _Nullable battlegroundsImageGold;
    if (battlegrounds[@"imageGold"]) {
        battlegroundsImageGold = [NSURL URLWithString:battlegrounds[@"imageGold"]];
    } else {
        battlegroundsImageGold = nil;
    }
    [hsCard->_battlegroundsImageGold release];
    hsCard->_battlegroundsImageGold = [battlegroundsImageGold copy];
    
    //
    
    hsCard->_version = HSCARD_LATEST_VERSION;
    
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
        _copy->_cardId = self.cardId;
        _copy->_collectible = self.collectible;
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
        
        [_copy->_classId release];
        _copy->_classId = [self.classId copyWithZone:zone];
        
        [_copy->_multiClassIds release];
        _copy->_multiClassIds = [self.multiClassIds copyWithZone:zone];
        
        [_copy->_minionTypeId release];
        _copy->_minionTypeId = [self.minionTypeId copyWithZone:zone];
        
        [_copy->_spellSchoolId release];
        _copy->_spellSchoolId = [self.spellSchoolId copyWithZone:zone];
        
        _copy->_cardTypeId = self.cardTypeId;
        _copy->_cardSetId = self.cardSetId;
        
        [_copy->_rarityId release];
        _copy->_rarityId = [self.rarityId copyWithZone:zone];
        
        [_copy->_artistName release];
        _copy->_artistName = [self.artistName copyWithZone:zone];
        
        _copy->_health = self.health;
        _copy->_attack = self.attack;
        _copy->_manaCost = self.manaCost;
        
        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
        
        [_copy->_text release];
        _copy->_text = [self.text copyWithZone:zone];
        
        [_copy->_image release];
        _copy->_image = [self.image copyWithZone:zone];
        
        [_copy->_imageGold release];
        _copy->_imageGold = [self.imageGold copyWithZone:zone];
        
        [_copy->_flavorText release];
        _copy->_flavorText = [self.flavorText copyWithZone:zone];
        
        [_copy->_cropImage release];
        _copy->_cropImage = [self.cropImage copyWithZone:zone];
        
        [_copy->_childIds release];
        _copy->_childIds = [self.childIds copyWithZone:zone];
        
        _copy->_parentId = self.parentId;
        
        [_copy->_battlegroundsTier release];
        _copy->_battlegroundsTier = [self.battlegroundsTier copyWithZone:zone];
        
        [_copy->_battlegroundsHero release];
        _copy->_battlegroundsHero = [self.battlegroundsHero copyWithZone:zone];
        
        [_copy->_battlegroundsUpgradeId release];
        _copy->_battlegroundsUpgradeId = [self.battlegroundsUpgradeId copyWithZone:zone];
        
        [_copy->_battlegroundsImage release];
        _copy->_battlegroundsImage = [self.battlegroundsImage copyWithZone:zone];
        
        [_copy->_battlegroundsImageGold release];
        _copy->_battlegroundsImageGold = [self.battlegroundsImageGold copyWithZone:zone];
        
        _copy->_version = self->_version;
    }
    
    return copy;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [self init];
    
    if (self) {
        NSUInteger version = [coder decodeIntegerForKey:@"version"];
        
        if (version == 0) {
            self->_cardId = [coder decodeIntegerForKey:@"cardId"];
            self->_collectible = [coder decodeIntegerForKey:@"collectible"];
            
            [self->_slug release];
            self->_slug = [[coder decodeObjectOfClass:[NSString class] forKey:@"slug"] copy];
            
            /* diff: 0 <-> 2 */
            [self->_classId release];
            self->_classId = [[NSNumber numberWithInteger:[coder decodeIntegerForKey:@"classId"]] copy];
            
            [self->_multiClassIds release];
            self->_multiClassIds = [[coder decodeObjectOfClass:[NSArray<NSNumber *> class] forKey:@"multiClassIds"] copy];
            
            /* diff: 0 <-> 1 */
            [self->_minionTypeId release];
            self->_minionTypeId = [[NSNumber numberWithInteger:[coder decodeIntegerForKey:@"minionTypeId"]] copy];
            
            /* diff: 0 <-> 2 */
            [self->_spellSchoolId release];
            self->_spellSchoolId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"spellSchoolId"] copy];
            
            /* diff: 0 <-> 2 */
            [self->_cardTypeId release];
            self->_cardTypeId = [[NSNumber numberWithInteger:[coder decodeIntegerForKey:@"cardTypeId"]] copy];
            
            /* diff: 0 <-> 2 */
            [self->_cardSetId release];
            self->_cardSetId = [[NSNumber numberWithInteger:[coder decodeIntegerForKey:@"cardSetId"]] copy];
            
            /* diff: 0 <-> 2 */
            [self->_rarityId release];
            self->_rarityId = [[NSNumber numberWithInteger:[coder decodeIntegerForKey:@"rarityId"]] copy];
            
            [self->_artistName release];
            self->_artistName = [[coder decodeObjectOfClass:[NSString class] forKey:@"artistName"] copy];
            
            self->_health = [coder decodeIntegerForKey:@"health"];
            self->_attack = [coder decodeIntegerForKey:@"attack"];
            self->_manaCost = [coder decodeIntegerForKey:@"manaCost"];
            
            [self->_name release];
            self->_name = [[coder decodeObjectOfClass:[NSString class] forKey:@"name"] copy];
            
            [self->_text release];
            self->_text = [[coder decodeObjectOfClass:[NSString class] forKey:@"text"] copy];
            
            [self->_image release];
            self->_image = [[coder decodeObjectOfClass:[NSURL class] forKey:@"image"] copy];
            
            [self->_imageGold release];
            self->_imageGold = [[coder decodeObjectOfClass:[NSURL class] forKey:@"imageGold"] copy];
            
            [self->_flavorText release];
            self->_flavorText = [[coder decodeObjectOfClass:[NSString class] forKey:@"flavorText"] copy];
            
            [self->_cropImage release];
            self->_cropImage = [[coder decodeObjectOfClass:[NSURL class] forKey:@"cropImage"] copy];
            
            [self->_childIds release];
            self->_childIds = [[coder decodeObjectOfClass:[NSArray<NSNumber *> class] forKey:@"childIds"] copy];
            
            /* diff: 0 <-> 2 */
            // gameModes is deleted.
            
            self->_parentId = [coder decodeIntegerForKey:@"parentId"];
            
            /* diff: 0 <-> 3 */
            [self->_battlegroundsTier release];
            self->_battlegroundsTier = nil;
            
            /* diff: 0 <-> 3 */
            [self->_battlegroundsHero release];
            self->_battlegroundsHero = nil;
            
            /* diff: 0 <-> 3 */
            [self->_battlegroundsUpgradeId release];
            self->_battlegroundsUpgradeId = nil;
            
            /* diff: 0 <-> 3 */
            [self->_battlegroundsImage release];
            self->_battlegroundsImage = nil;
            
            /* diff: 0 <-> 3 */
            [self->_battlegroundsImageGold release];
            self->_battlegroundsImageGold = nil;
            
            self->_version = HSCARD_LATEST_VERSION;
        } else if (version == 1) {
            self->_cardId = [coder decodeIntegerForKey:@"cardId"];
            self->_collectible = [coder decodeIntegerForKey:@"collectible"];
            
            [self->_slug release];
            self->_slug = [[coder decodeObjectOfClass:[NSString class] forKey:@"slug"] copy];
            
            /* diff: 1 <-> 2 */
            [self->_classId release];
            self->_classId = [[NSNumber numberWithInteger:[coder decodeIntegerForKey:@"classId"]] copy];
            
            [self->_multiClassIds release];
            self->_multiClassIds = [[coder decodeObjectOfClass:[NSArray<NSNumber *> class] forKey:@"multiClassIds"] copy];
            
            [self->_minionTypeId release];
            self->_minionTypeId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"minionTypeId"] copy];
            
            [self->_spellSchoolId release];
            self->_spellSchoolId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"spellSchoolId"] copy];
            
            /* diff: 1 <-> 2 */
            [self->_cardTypeId release];
            self->_cardTypeId = [[NSNumber numberWithInteger:[coder decodeIntegerForKey:@"cardTypeId"]] copy];
            
            /* diff: 1 <-> 2 */
            [self->_cardSetId release];
            self->_cardSetId = [[NSNumber numberWithInteger:[coder decodeIntegerForKey:@"cardSetId"]] copy];
            
            /* diff: 1 <-> 2 */
            [self->_rarityId release];
            self->_rarityId = [[NSNumber numberWithInteger:[coder decodeIntegerForKey:@"rarityId"]] copy];
            
            [self->_artistName release];
            self->_artistName = [[coder decodeObjectOfClass:[NSString class] forKey:@"artistName"] copy];
            
            self->_health = [coder decodeIntegerForKey:@"health"];
            self->_attack = [coder decodeIntegerForKey:@"attack"];
            self->_manaCost = [coder decodeIntegerForKey:@"manaCost"];
            
            [self->_name release];
            self->_name = [[coder decodeObjectOfClass:[NSString class] forKey:@"name"] copy];
            
            [self->_text release];
            self->_text = [[coder decodeObjectOfClass:[NSString class] forKey:@"text"] copy];
            
            [self->_image release];
            self->_image = [[coder decodeObjectOfClass:[NSURL class] forKey:@"image"] copy];
            
            [self->_imageGold release];
            self->_imageGold = [[coder decodeObjectOfClass:[NSURL class] forKey:@"imageGold"] copy];
            
            [self->_flavorText release];
            self->_flavorText = [[coder decodeObjectOfClass:[NSString class] forKey:@"flavorText"] copy];
            
            [self->_cropImage release];
            self->_cropImage = [[coder decodeObjectOfClass:[NSURL class] forKey:@"cropImage"] copy];
            
            [self->_childIds release];
            self->_childIds = [[coder decodeObjectOfClass:[NSArray<NSNumber *> class] forKey:@"childIds"] copy];
            
            /* diff: 1 <-> 2 */
            // gameModes is deleted.
            
            self->_parentId = [coder decodeIntegerForKey:@"parentId"];
            
            /* diff: 1 <-> 3 */
            [self->_battlegroundsTier release];
            self->_battlegroundsTier = nil;
            
            /* diff: 1 <-> 3 */
            [self->_battlegroundsHero release];
            self->_battlegroundsHero = nil;
            
            /* diff: 1 <-> 3 */
            [self->_battlegroundsUpgradeId release];
            self->_battlegroundsUpgradeId = nil;
            
            /* diff: 1 <-> 3 */
            [self->_battlegroundsImage release];
            self->_battlegroundsImage = nil;
            
            /* diff: 1 <-> 3 */
            [self->_battlegroundsImageGold release];
            self->_battlegroundsImageGold = nil;
            
            self->_version = HSCARD_LATEST_VERSION;
        } else if (version == 2) {
            self->_cardId = [coder decodeIntegerForKey:@"cardId"];
            self->_collectible = [coder decodeIntegerForKey:@"collectible"];
            
            [self->_slug release];
            self->_slug = [[coder decodeObjectOfClass:[NSString class] forKey:@"slug"] copy];
            
            [self->_classId release];
            self->_classId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"classId"] copy];
            
            [self->_multiClassIds release];
            self->_multiClassIds = [[coder decodeObjectOfClass:[NSArray<NSNumber *> class] forKey:@"multiClassIds"] copy];
            
            [self->_minionTypeId release];
            self->_minionTypeId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"minionTypeId"] copy];
            
            [self->_spellSchoolId release];
            self->_spellSchoolId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"spellSchoolId"] copy];
            
            [self->_cardTypeId release];
            self->_cardTypeId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"cardTypeId"] copy];
            
            [self->_cardSetId release];
            self->_cardSetId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"cardSetId"] copy];
            
            [self->_rarityId release];
            self->_rarityId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"rarityId"] copy];
            
            [self->_artistName release];
            self->_artistName = [[coder decodeObjectOfClass:[NSString class] forKey:@"artistName"] copy];
            
            self->_health = [coder decodeIntegerForKey:@"health"];
            self->_attack = [coder decodeIntegerForKey:@"attack"];
            self->_manaCost = [coder decodeIntegerForKey:@"manaCost"];
            
            [self->_name release];
            self->_name = [[coder decodeObjectOfClass:[NSString class] forKey:@"name"] copy];
            
            [self->_text release];
            self->_text = [[coder decodeObjectOfClass:[NSString class] forKey:@"text"] copy];
            
            [self->_image release];
            self->_image = [[coder decodeObjectOfClass:[NSURL class] forKey:@"image"] copy];
            
            [self->_imageGold release];
            self->_imageGold = [[coder decodeObjectOfClass:[NSURL class] forKey:@"imageGold"] copy];
            
            [self->_flavorText release];
            self->_flavorText = [[coder decodeObjectOfClass:[NSString class] forKey:@"flavorText"] copy];
            
            [self->_cropImage release];
            self->_cropImage = [[coder decodeObjectOfClass:[NSURL class] forKey:@"cropImage"] copy];
            
            [self->_childIds release];
            self->_childIds = [[coder decodeObjectOfClass:[NSArray<NSNumber *> class] forKey:@"childIds"] copy];
            
            self->_parentId = [coder decodeIntegerForKey:@"parentId"];
            
            /* diff: 2 <-> 3 */
            [self->_battlegroundsTier release];
            self->_battlegroundsTier = nil;
            
            /* diff: 2 <-> 3 */
            [self->_battlegroundsHero release];
            self->_battlegroundsHero = nil;
            
            /* diff: 2 <-> 3 */
            [self->_battlegroundsUpgradeId release];
            self->_battlegroundsUpgradeId = nil;
            
            /* diff: 2 <-> 3 */
            [self->_battlegroundsImage release];
            self->_battlegroundsImage = nil;
            
            /* diff: 2 <-> 3 */
            [self->_battlegroundsImageGold release];
            self->_battlegroundsImageGold = nil;
            
            self->_version = HSCARD_LATEST_VERSION;
        } else {
            self->_cardId = [coder decodeIntegerForKey:@"cardId"];
            self->_collectible = [coder decodeIntegerForKey:@"collectible"];
            
            [self->_slug release];
            self->_slug = [[coder decodeObjectOfClass:[NSString class] forKey:@"slug"] copy];
            
            [self->_classId release];
            self->_classId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"classId"] copy];
            
            [self->_multiClassIds release];
            self->_multiClassIds = [[coder decodeObjectOfClass:[NSArray<NSNumber *> class] forKey:@"multiClassIds"] copy];
            
            [self->_minionTypeId release];
            self->_minionTypeId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"minionTypeId"] copy];
            
            [self->_spellSchoolId release];
            self->_spellSchoolId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"spellSchoolId"] copy];
            
            [self->_cardTypeId release];
            self->_cardTypeId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"cardTypeId"] copy];
            
            [self->_cardSetId release];
            self->_cardSetId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"cardSetId"] copy];
            
            [self->_rarityId release];
            self->_rarityId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"rarityId"] copy];
            
            [self->_artistName release];
            self->_artistName = [[coder decodeObjectOfClass:[NSString class] forKey:@"artistName"] copy];
            
            self->_health = [coder decodeIntegerForKey:@"health"];
            self->_attack = [coder decodeIntegerForKey:@"attack"];
            self->_manaCost = [coder decodeIntegerForKey:@"manaCost"];
            
            [self->_name release];
            self->_name = [[coder decodeObjectOfClass:[NSString class] forKey:@"name"] copy];
            
            [self->_text release];
            self->_text = [[coder decodeObjectOfClass:[NSString class] forKey:@"text"] copy];
            
            [self->_image release];
            self->_image = [[coder decodeObjectOfClass:[NSURL class] forKey:@"image"] copy];
            
            [self->_imageGold release];
            self->_imageGold = [[coder decodeObjectOfClass:[NSURL class] forKey:@"imageGold"] copy];
            
            [self->_flavorText release];
            self->_flavorText = [[coder decodeObjectOfClass:[NSString class] forKey:@"flavorText"] copy];
            
            [self->_cropImage release];
            self->_cropImage = [[coder decodeObjectOfClass:[NSURL class] forKey:@"cropImage"] copy];
            
            [self->_childIds release];
            self->_childIds = [[coder decodeObjectOfClass:[NSArray<NSNumber *> class] forKey:@"childIds"] copy];
            
            self->_parentId = [coder decodeIntegerForKey:@"parentId"];
            
            [self->_battlegroundsTier release];
            self->_battlegroundsTier = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"battlegroundsTier"] copy];
            
            [self->_battlegroundsHero release];
            self->_battlegroundsHero = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"battlegroundsHero"] copy];
            
            [self->_battlegroundsUpgradeId release];
            self->_battlegroundsUpgradeId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"battlegroundsUpgradeId"] copy];
            
            [self->_battlegroundsImage release];
            self->_battlegroundsImage = [[coder decodeObjectOfClass:[NSURL class] forKey:@"battlegroundsImage"] copy];
            
            [self->_battlegroundsImageGold release];
            self->_battlegroundsImageGold = [[coder decodeObjectOfClass:[NSURL class] forKey:@"battlegroundsImageGold"] copy];
            
            self->_version = HSCARD_LATEST_VERSION;
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.cardId forKey:@"cardId"];
    [coder encodeInteger:self.collectible forKey:@"collectible"];
    [coder encodeObject:self.slug forKey:@"slug"];
    [coder encodeObject:self.classId forKey:@"classId"];
    [coder encodeObject:self.multiClassIds forKey:@"multiClassIds"];
    [coder encodeObject:self.minionTypeId forKey:@"minionTypeId"];
    [coder encodeObject:self.spellSchoolId forKey:@"spellSchoolId"];
    [coder encodeObject:self.cardTypeId forKey:@"cardTypeId"];
    [coder encodeObject:self.cardSetId forKey:@"cardSetId"];
    [coder encodeObject:self.rarityId forKey:@"rarityId"];
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
    [coder encodeInteger:self.parentId forKey:@"parentId"];
    [coder encodeObject:self.battlegroundsTier forKey:@"battlegroundsTier"];
    [coder encodeObject:self.battlegroundsHero forKey:@"battlegroundsHero"];
    [coder encodeObject:self.battlegroundsUpgradeId forKey:@"battlegroundsUpgradeId"];
    [coder encodeObject:self.battlegroundsImage forKey:@"battlegroundsImage"];
    [coder encodeObject:self.battlegroundsImageGold forKey:@"battlegroundsImageGold"];
    [coder encodeInteger:self.version forKey:@"version"];
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

#if TARGET_OS_OSX

#pragma mark - NSPasteboardWriting

- (nonnull NSArray<NSPasteboardType> *)writableTypesForPasteboard:(nonnull NSPasteboard *)pasteboard {
    return @[NSPasteboardTypeHSCard];
}

- (id)pasteboardPropertyListForType:(NSPasteboardType)type {
    if ([type isEqualToString:NSPasteboardTypeHSCard]) {
        NSData *hsCardsData = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:YES error:nil];
        return hsCardsData;
    } else {
        return nil;
    }
}

#pragma mark - NSPasteboardReading

+ (NSArray<NSPasteboardType> *)readableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return @[NSPasteboardTypeHSCard];
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(NSPasteboardType)type pasteboard:(NSPasteboard *)pasteboard {
    return NSPasteboardReadingAsKeyedArchive;
}

- (id)initWithPasteboardPropertyList:(id)propertyList ofType:(NSPasteboardType)type {
    if (![type isEqualToString:NSPasteboardTypeHSCard]) {
        return nil;
    }
    
    NSError * _Nullable error = nil;
    NSKeyedUnarchiver *coder = [[NSKeyedUnarchiver alloc] initForReadingFromData:propertyList error:&error];
    
    if (error != nil) {
        NSLog(@"%@", error);
        [coder release];
        return nil;
    }
    
    self = [self initWithCoder:coder];
    [coder finishDecoding];
    [coder release];
    
    return self;
}

#endif

@end
