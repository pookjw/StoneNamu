//
//  UIViewController+presentErrorAlert.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "UIViewController+presentErrorAlert.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

@implementation UIViewController (presentErrorAlert)

- (void)presentErrorAlertWithError:(NSError *)error {
    NSString * _Nullable message;
    
    if ([error isKindOfClass:[StoneNamuError class]]) {
        StoneNamuError *stoneNamuError = (StoneNamuError *)error;
        message = [ResourcesService localizationForKey:stoneNamuError.type];
    } else {
        message = error.localizedDescription;
    }
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:[ResourcesService localizationForKey:LocalizableKeyErrorAlertTitle]
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyDismiss]
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {}];
    
    [vc addAction:dismissAction];
    [self presentViewController:vc animated:YES completion:^{}];
}

@end
