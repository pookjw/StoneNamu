//
//  HSCardClass.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * HSCardClassSlugType NS_TYPED_EXTENSIBLE_ENUM;
static HSCardClassSlugType const HSCardClassSlugTypeNeutral = @"neutral";
static HSCardClassSlugType const HSCardClassSlugTypeDemonHunder = @"demonhunter";
static HSCardClassSlugType const HSCardClassSlugTypeDeathKnight = @"deathknight";
static HSCardClassSlugType const HSCardClassSlugTypeDruid = @"druid";
static HSCardClassSlugType const HSCardClassSlugTypeHunter = @"hunter";
static HSCardClassSlugType const HSCardClassSlugTypeMage = @"mage";
static HSCardClassSlugType const HSCardClassSlugTypePaladin = @"paladin";
static HSCardClassSlugType const HSCardClassSlugTypePriest = @"priest";
static HSCardClassSlugType const HSCardClassSlugTypeRogue = @"rogue";
static HSCardClassSlugType const HSCardClassSlugTypeShaman = @"shaman";
static HSCardClassSlugType const HSCardClassSlugTypeWarlock = @"warlock";
static HSCardClassSlugType const HSCardClassSlugTypeWarrior = @"warrior";

@interface HSCardClass : NSObject <NSCopying>
@property (readonly, copy) HSCardClassSlugType slug;
@property (readonly, copy) NSNumber *classId;
@property (readonly, copy) NSString *name;
@property (readonly, copy) NSNumber *heroCardId;
@property (readonly, copy) NSNumber *heroPowerCardId;
@property (readonly, copy) NSSet<NSNumber *> *alternateHeroCardIds;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (HSCardClass * _Nullable)hsCardClassFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
