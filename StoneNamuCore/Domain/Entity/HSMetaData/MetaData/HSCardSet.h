//
//  HSCardSet.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HSCardSetIdType) {
    HSCardSetIdTypeStandardCards = 9002,
    HSCardSetIdTypeWildCards = 9001
};

typedef NSString * HSCardSetSlugType NS_TYPED_EXTENSIBLE_ENUM;
static HSCardSetSlugType const HSCardSetSlugTypeClassicCards = @"classic-cards";
static HSCardSetSlugType const HSCardSetSlugTypeStandardCards = @"standard";
static HSCardSetSlugType const HSCardSetSlugTypeWildCards = @"wild";

@interface HSCardSet : NSObject <NSCopying>
@property (readonly, copy) NSNumber *setId;
@property (readonly, copy) NSString *name;
@property (readonly, copy) NSString *slug;
@property (readonly, copy) NSSet<NSNumber *> *aliasSetIds;
@property (readonly, copy) NSString *type;
@property (readonly, copy) NSNumber *collectibleCount;
@property (readonly, copy) NSNumber *collectibleRevealedCount;
@property (readonly, copy) NSNumber *nonCollectibleCount;
@property (readonly, copy) NSNumber *nonCollectibleRevealedCount;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (HSCardSet * _Nullable)hsCardSetFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
