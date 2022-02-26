//
//  HSCardType.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * HSCardTypeSlugType NS_TYPED_EXTENSIBLE_ENUM;
static HSCardTypeSlugType const HSCardTypeSlugTypeMinion = @"minion";
static HSCardTypeSlugType const HSCardTypeSlugTypeHero = @"hero";

@interface HSCardType : NSObject <NSCopying>
@property (readonly, copy) NSString *slug;
@property (readonly, copy) NSNumber *typeId;
@property (readonly, copy) NSString *name;
@property (readonly, copy) NSSet<NSNumber *> *gameModes;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (HSCardType * _Nullable)hsCardTypeFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
