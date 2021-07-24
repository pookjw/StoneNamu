//
//  UIViewController+presentErrorAlert.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "UIViewController+presentErrorAlert.h"

@implementation UIViewController (presentErrorAlert)

- (void)presentErrorAlertWithError:(NSError *)error {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"ERROR! (번역)"
                                                                message:error.localizedDescription
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"확인 (번역)"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {}];
    
    [vc addAction:doneAction];
    [self presentViewController:vc animated:YES completion:^{}];
}

@end
