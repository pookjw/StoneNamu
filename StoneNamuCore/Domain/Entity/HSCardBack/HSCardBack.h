//
//  HSCardBack.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 3/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSCardBack : NSObject <NSCopying>
@property (readonly) NSUInteger cardBackId;
@property (readonly) NSUInteger sortCategory;
@property (readonly, copy) NSString *text;
@property (readonly, copy) NSString *name;
@property (readonly, copy) NSURL *image;
@property (readonly, copy) NSString *slug;
+ (HSCardBack *)hsCardBackFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
+ (NSArray<HSCardBack *> *)hsCardBacksFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
