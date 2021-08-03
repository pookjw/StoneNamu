//
//  PickerItemModel.h
//  PickerItemModel
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickerItemModel : NSObject
@property (readonly, copy) UIImage * _Nullable image;
@property (readonly, copy) NSString *title;
@property (readonly, copy) NSString *identity;
- (instancetype)initWithImage:(UIImage * _Nullable)image title:(NSString *)title identity:(NSString *)identity;
@end

NS_ASSUME_NONNULL_END
