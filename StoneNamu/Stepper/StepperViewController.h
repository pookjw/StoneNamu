//
//  StepperViewController.h
//  StepperViewController
//
//  Created by Jinwoo Kim on 7/29/21.
//

#import <UIKit/UIKit.h>

typedef void (^StepperViewControllerDoneCompletion)(NSUInteger);

NS_ASSUME_NONNULL_BEGIN

@interface StepperViewController : UIViewController
- (instancetype)initWithRange:(NSRange)range title:(NSString *)title value:(NSUInteger)value;
@end

NS_ASSUME_NONNULL_END
