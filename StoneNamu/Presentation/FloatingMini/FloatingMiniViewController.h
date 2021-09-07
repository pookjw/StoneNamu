//
//  FloatingMiniViewController.h
//  FloatingMiniViewController
//
//  Created by Jinwoo Kim on 9/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

# define FLOATINGMINIVIEWCONTROLLER_CONTENTVIEW_CORNER_RADIUS 25

@interface FloatingMiniViewController : UIViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithContentViewController:(__kindof UIViewController *)viewController;
- (instancetype)initWithContentViewController:(__kindof UIViewController *)viewController sizeOfContentView:(CGSize)sizeOfContentView;
@end

NS_ASSUME_NONNULL_END
