//
//  HSCard.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "HSCard.h"

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
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[HSCard class]]) {
        return NO;
    }
    
    HSCard *toCompare = (HSCard *)object;
    
    return (self.cardId == toCompare.cardId) && ([self.slug isEqualToString:toCompare.slug]);
}

+ (HSCard * _Nullable)hsCardFromJSONData:(NSData *)data error:(NSError **)error {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:error];
    
    if (*error) {
        return nil;
    }
    
    HSCard *hsCard = [HSCard hsCardFromDic:dic];
    return hsCard;
}

+ (NSArray<HSCard *> *)hsCardsFromJSONData:(NSData *)data error:(NSError **)error {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:error];
    
    if (*error) {
        return @[];
    }
    
    NSArray *cards = dic[@"cards"];
    NSMutableArray *hsCards = [[@[] mutableCopy] autorelease];
    
    for (NSDictionary *card in cards) {
        @autoreleasepool {
            HSCard *hsCard = [HSCard hsCardFromDic:card];
            [hsCards addObject:hsCard];
        }
    }
    
    return hsCards;
}

+ (HSCard *)hsCardFromDic:(NSDictionary *)dic {
    HSCard *hsCard = [[HSCard new] autorelease];
    
    hsCard->_cardId = [(NSNumber *)dic[@"id"] unsignedIntegerValue];
    hsCard->_collectible = [(NSNumber *)dic[@"collectible"] boolValue];
    hsCard->_slug = [dic[@"slug"] retain];
    hsCard->_classId = [(NSNumber *)dic[@"classId"] unsignedIntegerValue];
    hsCard->_multiClassIds = [dic[@"multiClassIds"] retain];
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
    if ([artistName isEqual:[NSNull null]]) {
        hsCard->_artistName = nil;
    } else {
        hsCard->_artistName = [artistName retain];
    }
    
    hsCard->_health = [(NSNumber *)dic[@"health"] unsignedIntegerValue];
    hsCard->_attack = [(NSNumber *)dic[@"attack"] unsignedIntegerValue];
    hsCard->_manaCost = [(NSNumber *)dic[@"manaCost"] unsignedIntegerValue];
    
    id name = dic[@"name"];
    if ([name isEqual:[NSNull null]]) {
        hsCard->_name = nil;
    } else {
        hsCard->_name = [name retain];
    }
    
    hsCard->_text = [dic[@"text"] retain];
    hsCard->_image = [[NSURL URLWithString:dic[@"image"]] retain];
    hsCard->_imageGold = [[NSURL URLWithString:dic[@"imageGold"]] retain];
    hsCard->_flavorText = [dic[@"flavorText"] retain];
    
    id cropImage = dic[@"cropImage"];
    if ([cropImage isEqual:[NSNull null]]) {
        hsCard->_cropImage = nil;
    } else {
        hsCard->_cropImage = [[NSURL URLWithString:(NSString *)cropImage] retain];
    }

    hsCard->_childIds = [dic[@"childIds"] retain];
    
    return hsCard;
}

@end
