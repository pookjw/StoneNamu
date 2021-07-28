//
//  HSCard.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <Foundation/Foundation.h>
#import "HSCardSet.h"
#import "HSCardClass.h"
#import "HSCardRarity.h"
#import "HSCardCollectible.h"
#import "HSCardType.h"
#import "HSCardMinionType.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSCard : NSObject
@property (readonly) NSInteger cardId;
@property (readonly) HSCardCollectible collectible;
@property (readonly, retain) NSString *slug;
@property (readonly) HSCardClass classId;
@property (readonly, retain) NSArray<NSNumber *> *multiClassIds;
@property (readonly) HSCardMinionType minionTypeId;
@property (readonly) HSCardType cardTypeId;
@property (readonly) HSCardSet cardSetId;
@property (readonly) HSCardRarity rarityId;
@property (readonly, retain) NSString * _Nullable artistName;
@property (readonly) NSInteger health;
@property (readonly) NSInteger attack;
@property (readonly) NSInteger manaCost;
@property (readonly, retain) NSString * _Nullable name;
@property (readonly, retain) NSString *text;
@property (readonly, retain) NSURL *image;
@property (readonly, retain) NSURL * _Nullable imageGold;
@property (readonly, retain) NSString *flavorText;
@property (readonly, retain) NSURL * _Nullable cropImage;
@property (readonly, retain) NSArray<NSNumber *> *childIds;
+ (HSCard * _Nullable)hsCardFromJSONData:(NSData *)data error:(NSError **)error;
+ (NSArray<HSCard *> *)hsCardsFromJSONData:(NSData *)data error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
