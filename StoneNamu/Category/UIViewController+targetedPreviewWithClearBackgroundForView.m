//
//  UIViewController+targetedPreviewWithClearBackgroundForView.m
//  UIViewController+targetedPreviewWithClearBackgroundForView
//
//  Created by Jinwoo Kim on 9/3/21.
//

#import "UIViewController+targetedPreviewWithClearBackgroundForView.h"

@implementation UIViewController (targetedPreviewWithClearBackgroundForView)

- (UITargetedPreview *)targetedPreviewWithClearBackgroundForView:(UIView *)view {
    UIPreviewParameters *parameters = [[UIPreviewParameters new] autorelease];
    parameters.backgroundColor = UIColor.clearColor;
    
    return [[[UITargetedPreview alloc] initWithView:view parameters:parameters] autorelease];
}

@end
