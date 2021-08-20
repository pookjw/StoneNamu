//
//  HSCard.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "HSCard.h"
#import "StoneNamuCoreErrors.h"

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

- (NSUInteger)hash {
    return self.cardId ^ self.slug.hash;
}

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
    }
    
    return copy;
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
        NSLog(@"Noti!!!%@", hsCard->_slug);
        hsCard->_classId = HSCardClassNeutral;
    } else {
        hsCard->_classId = [(NSNumber *)classId unsignedIntegerValue];
    }
    
    hsCard->_multiClassIds = [dic[@"multiClassIds"] copy];
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
    
    return [hsCard autorelease];
}

@end
