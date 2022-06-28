//
//  HSDeck.h
//  HSDeck
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSCard.h>
#import <StoneNamuCore/HSDeckFormat.h>

#define HSDECK_MAX_TOTAL_CARDS 50
#define HSDECK_MAX_TOTAL_CARDS_NORMAL 30
#define HSDECK_MAX_TOTAL_CARDS_PRINCE_RENATHAL 40
#define PRINCE_RENATHAL_CARD_ID 79767

#define HSDECK_MAX_SINGLE_CARD 2
#define HSDECK_MAX_SINGLE_LEGENDARY_CARD 1

NS_ASSUME_NONNULL_BEGIN

@interface HSDeck : NSObject <NSCopying>
@property (readonly, copy) NSString *deckCode;
@property (readonly, copy) HSDeckFormat format;
@property (readonly, copy) NSNumber *classId;
@property (readonly, copy) NSArray<HSCard *> *cards;
+ (HSDeck * _Nullable)hsDeckFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
