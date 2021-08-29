//
//  StepperViewController.h
//  StepperViewController
//
//  Created by Jinwoo Kim on 7/29/21.
//

#import <UIKit/UIKit.h>

typedef void (^StepperViewControllerDoneCompletion)(NSUInteger);
typedef void (^StepperViewControllerClearCompletion)(void);

NS_ASSUME_NONNULL_BEGIN

@interface StepperViewController : UIViewController
@property BOOL showPlusMarkWhenReachedToMax;
- (instancetype)initWithRange:(NSRange)range
                        title:(NSString *)title
                        value:(NSUInteger)value
              clearCompletion:(StepperViewControllerClearCompletion)clearCompletion
               doneCompletion:(StepperViewControllerDoneCompletion)doneCompletion;
@end

NS_ASSUME_NONNULL_END
