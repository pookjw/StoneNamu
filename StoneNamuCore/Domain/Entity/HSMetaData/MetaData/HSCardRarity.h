//
//  HSCardRarity.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * HSCardRaritySlugType NS_TYPED_EXTENSIBLE_ENUM;
static HSCardRaritySlugType const HSCardRaritySlugTypeFree = @"free";
static HSCardRaritySlugType const HSCardRaritySlugTypeCommon = @"common";
static HSCardRaritySlugType const HSCardRaritySlugTypeRare = @"rare";
static HSCardRaritySlugType const HSCardRaritySlugTypeEpic = @"epic";
static HSCardRaritySlugType const HSCardRaritySlugTypeLegendary = @"legendary";

@interface HSCardRarity : NSObject <NSCopying>
@property (readonly, copy) HSCardRaritySlugType slug;
@property (readonly, copy) NSNumber *rarityId;
@property (readonly, copy) NSSet<NSNumber *> *craftingCost;
@property (readonly, copy) NSSet<NSNumber *> *dustValue;
@property (readonly, copy) NSString *name;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (HSCardRarity * _Nullable)hsCardRarityFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
