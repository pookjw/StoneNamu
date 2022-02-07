//
//  HSCardSpellSchool.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSCardSpellSchool : NSObject <NSCopying>
@property (readonly, copy) NSString *slug;
@property (readonly, copy) NSNumber *spellSchoolId;
@property (readonly, copy) NSString *name;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (HSCardSpellSchool * _Nullable)hsCardSpellSchoolFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
