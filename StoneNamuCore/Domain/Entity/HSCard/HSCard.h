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
#import "HSCardKeyword.h"
#import "HSCardGameMode.h"
#import "HSCardSort.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSCard : NSObject <NSCopying>
@property (readonly) NSUInteger cardId;
@property (readonly) HSCardCollectible collectible;
@property (readonly, copy) NSString *slug;
@property (readonly) HSCardClass classId;
@property (readonly, copy) NSArray<NSNumber *> *multiClassIds;
@property (readonly) HSCardMinionType minionTypeId;
@property (readonly) HSCardType cardTypeId;
@property (readonly) HSCardSet cardSetId;
@property (readonly) HSCardRarity rarityId;
@property (readonly, copy) NSString * _Nullable artistName;
@property (readonly) NSUInteger health;
@property (readonly) NSUInteger attack;
@property (readonly) NSUInteger manaCost;
@property (readonly, copy) NSString * _Nullable name;
@property (readonly, copy) NSString *text;
@property (readonly, copy) NSURL *image;
@property (readonly, copy) NSURL * _Nullable imageGold;
@property (readonly, copy) NSString *flavorText;
@property (readonly, copy) NSURL * _Nullable cropImage;
@property (readonly, copy) NSArray<NSNumber *> *childIds;
@property (readonly, copy) NSArray<NSNumber *> *gameModes;
+ (HSCard * _Nullable)hsCardFromDic:(NSDictionary *)dic error:(NSError ** _Nullable)error;
+ (NSArray<HSCard *> *)hsCardsFromDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
