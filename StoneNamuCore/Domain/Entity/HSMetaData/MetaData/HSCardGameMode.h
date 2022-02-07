//
//  HSCardGameMode.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * HSCardGameModeSlugType NS_TYPED_EXTENSIBLE_ENUM;
static HSCardGameModeSlugType const HSCardGameModeSlugTypeConstructed = @"constructed";
static HSCardGameModeSlugType const HSCardGameModeSlugTypeBattlegrounds = @"battlegrounds";
static HSCardGameModeSlugType const HSCardGameModeSlugTypeArena = @"arena";
static HSCardGameModeSlugType const HSCardGameModeSlugTypeDuels = @"duels";
static HSCardGameModeSlugType const HSCardGameModeSlugTypeStandard = @"standard";
static HSCardGameModeSlugType const HSCardGameModeSlugTypeMercenaries = @"mercenaries";

@interface HSCardGameMode : NSObject <NSCopying>
@property (readonly, copy) NSString *slug;
@property (readonly, copy) NSNumber *gameModeId;
@property (readonly, copy) NSString *name;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (HSCardGameMode * _Nullable)hsCardGameModeFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
