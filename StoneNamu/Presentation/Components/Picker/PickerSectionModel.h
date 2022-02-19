//
//  PickerSectionModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PickerSectionModelType) {
    PickerSectionModelTypeEmpty,
    PickerSectionModelTypeItems
};

@interface PickerSectionModel : NSObject
@property (readonly) PickerSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(PickerSectionModelType)type;
- (NSComparisonResult)compare:(PickerSectionModel *)other;
@end

NS_ASSUME_NONNULL_END
