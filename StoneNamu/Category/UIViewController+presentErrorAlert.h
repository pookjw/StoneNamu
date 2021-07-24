//
//  UIViewController+presentErrorAlert.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (presentErrorAlert)
- (void)presentErrorAlertWithError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
