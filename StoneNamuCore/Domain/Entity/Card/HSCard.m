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
            HSCard *hsCard = [HSCard new];
            
            hsCard->_id = [(NSNumber *)card[@"id"] integerValue];
            hsCard->_collectible = [(NSNumber *)card[@"collectible"] boolValue];
            hsCard->_slug = [card[@"slug"] retain];
            hsCard->_classId = [(NSNumber *)card[@"classId"] integerValue];
            hsCard->_multiClassIds = [card[@"multiClassIds"] retain];
            hsCard->_cardSetId = [(NSNumber *)card[@"cardSetId"] integerValue];
            hsCard->_rarityId = [(NSNumber *)card[@"rarityId"] integerValue];
            hsCard->_artistName = [card[@"artistName"] retain];
            hsCard->_health = [(NSNumber *)card[@"health"] integerValue];
            hsCard->_attack = [(NSNumber *)card[@"attack"] integerValue];
            hsCard->_manaCost = [(NSNumber *)card[@"manaCost"] integerValue];
            hsCard->_name = [card[@"name"] retain];
            hsCard->_text = [card[@"text"] retain];
            hsCard->_image = [[NSURL URLWithString:card[@"image"]] retain];
            hsCard->_imageGold = [[NSURL URLWithString:card[@"imageGold"]] retain];
            hsCard->_flavorText = [card[@"flavorText"] retain];
            hsCard->_cropImage = [[NSURL URLWithString:card[@"cropImage"]] retain];
            hsCard->_childIds = [card[@"childIds"] retain];
            
            [hsCards addObject:hsCard];
            [hsCard release];
        }
    }
    
    return hsCards;
}

@end
