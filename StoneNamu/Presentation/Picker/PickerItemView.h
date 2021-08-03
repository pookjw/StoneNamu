//
//  PickerItemView.h
//  PickerItemView
//
//  Created by Jinwoo Kim on 7/26/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickerItemView : UIView
+ (CGFloat)getHeightUsingWidth:(CGFloat)width;
- (void)configureWithImage:(UIImage * _Nullable)image primaryText:(NSString *)primaryText secondaryText:(NSString * _Nullable)secondaryText;
@end

NS_ASSUME_NONNULL_END
