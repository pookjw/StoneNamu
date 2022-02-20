//
//  PickerSectionModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickerSectionModel : NSObject <NSCopying>
@property (readonly) NSUInteger type;
@property (readonly, copy) NSString * _Nullable title;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(NSUInteger)type title:(NSString * _Nullable)title;
- (NSComparisonResult)compare:(PickerSectionModel *)other;
@end

NS_ASSUME_NONNULL_END
