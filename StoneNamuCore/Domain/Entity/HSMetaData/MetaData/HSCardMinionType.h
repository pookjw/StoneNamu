//
//  HSCardMinionType.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSCardMinionType : NSObject <NSCopying>
@property (readonly, copy) NSString *slug;
@property (readonly, copy) NSNumber *minionTypeId;
@property (readonly, copy) NSString *name;
@property (readonly, copy) NSSet<NSNumber *> *gameModes;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (HSCardMinionType * _Nullable)hsCardMinionTypeFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
