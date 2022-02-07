//
//  HSCardSetGroups.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * HSCardSetGroupsSlugType NS_TYPED_EXTENSIBLE_ENUM;
static HSCardSetGroupsSlugType const HSCardSetGroupsSlugTypeStandard = @"standard";
static HSCardSetGroupsSlugType const HSCardSetGroupsSlugTypeWild = @"wild";

@interface HSCardSetGroups : NSObject <NSCopying>
@property (readonly, copy) NSString *slug;
@property (readonly, copy) NSNumber *year;
@property (readonly, copy) NSURL *svg;
@property (readonly, copy) NSSet<NSString *> *cardSets;
@property (readonly, copy) NSString *name;
@property (readonly, copy) NSNumber * _Nullable standard;
@property (readonly, copy) NSString * _Nullable icon;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (HSCardSetGroups * _Nullable)hsCardSetGroupsFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
