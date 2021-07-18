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
    
    hsCard->_id = [(NSNumber *)dic[@"id"] integerValue];
    hsCard->_collectible = [(NSNumber *)dic[@"collectible"] boolValue];
    hsCard->_slug = [dic[@"slug"] retain];
    hsCard->_classId = [(NSNumber *)dic[@"classId"] integerValue];
    hsCard->_multiClassIds = [dic[@"multiClassIds"] retain];
    hsCard->_cardSetId = [(NSNumber *)dic[@"cardSetId"] integerValue];
    hsCard->_rarityId = [(NSNumber *)dic[@"rarityId"] integerValue];
    hsCard->_artistName = [dic[@"artistName"] retain];
    hsCard->_health = [(NSNumber *)dic[@"health"] integerValue];
    hsCard->_attack = [(NSNumber *)dic[@"attack"] integerValue];
    hsCard->_manaCost = [(NSNumber *)dic[@"manaCost"] integerValue];
    hsCard->_name = [dic[@"name"] retain];
    hsCard->_text = [dic[@"text"] retain];
    hsCard->_image = [[NSURL URLWithString:dic[@"image"]] retain];
    hsCard->_imageGold = [[NSURL URLWithString:dic[@"imageGold"]] retain];
    hsCard->_flavorText = [dic[@"flavorText"] retain];
    hsCard->_cropImage = [[NSURL URLWithString:dic[@"cropImage"]] retain];
    hsCard->_childIds = [dic[@"childIds"] retain];
    
    return hsCard;
}

@end
