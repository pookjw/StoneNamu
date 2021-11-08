//
//  NSSemaphoreCondition.h
//  NSSemaphoreCondition
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SemaphoreCondition : NSCondition
@property (readonly) NSInteger value;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithValue:(NSInteger)value;
@end

NS_ASSUME_NONNULL_END
