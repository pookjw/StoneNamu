//
//  PickerItemModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PickerItemModelType) {
    PickerItemModelTypeEmpty,
    PickerItemModelTypeItems
};

@interface PickerItemModel : NSObject <NSCopying>
@property (readonly) PickerItemModelType type;
@property (readonly) NSUInteger sectionType;
@property (readonly, copy) NSString * _Nullable key;
@property (readonly, copy) NSString * _Nullable text;
@property (getter=isSelected) BOOL selected;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initEmptyWithSectionType:(NSUInteger)sectionType IsSelected:(BOOL)isSelected;
- (instancetype)initWithSectionType:(NSUInteger)sectionType key:(NSString *)key text:(NSString *)text isSelected:(BOOL)isSelected;
@end

NS_ASSUME_NONNULL_END
