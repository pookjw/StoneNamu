//
//  OldPickerItemModel.h
//  OldPickerItemModel
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OldPickerItemModel : NSObject
@property (readonly, copy) UIImage * _Nullable image;
@property (readonly, copy) NSString *title;
@property (readonly, copy) NSString *identity;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithImage:(UIImage * _Nullable)image title:(NSString *)title identity:(NSString *)identity;
@end

NS_ASSUME_NONNULL_END
