//
//  TextActivityViewController.h
//  TextActivityViewController
//
//  Created by Jinwoo Kim on 9/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextActivityViewController : UIViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
