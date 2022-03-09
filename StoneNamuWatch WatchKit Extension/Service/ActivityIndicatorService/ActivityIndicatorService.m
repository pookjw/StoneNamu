//
//  ActivityIndicatorService.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/9/22.
//

#import "ActivityIndicatorService.h"
#import <objc/runtime.h>

static NSString * const ActivityIndicatorServiceVisualEffectViewItemKey = @"ActivityIndicatorServiceVisualEffectViewItemKey";

@implementation ActivityIndicatorService

- (void)showActivityIndicatorViewOnView:(id)view superviewIfNeeded:(BOOL)superviewIfNeeded {
    id targetView;
    
    if (superviewIfNeeded && [view superview]) {
        targetView = [view superview];
    } else {
        targetView = view;
    }
    
    if ([self visualEffectViewFromView:targetView]) return;
    
    id visualEffectView = [[NSClassFromString(@"UIVisualEffectView") alloc] initWithEffect:[NSClassFromString(@"UIBlurEffect") effectWithStyle:3]]; // UIBlurEffectStyleDark
    
    [targetView addSubview:visualEffectView];
    [visualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [[visualEffectView layer] setCornerRadius:10.0f];
    [[visualEffectView layer] setCornerCurve:@"continuous"]; // kCACornerCurveContinuous
    [visualEffectView setClipsToBounds:YES];
    
    [NSClassFromString(@"NSLayoutConstraint") activateConstraints:@[
        [[visualEffectView centerXAnchor] constraintEqualToAnchor:[targetView centerXAnchor]],
        [[visualEffectView centerYAnchor] constraintEqualToAnchor:[targetView centerYAnchor]],
    ]];
    
    id activityIndicatorView = [NSClassFromString(@"PUICActivityIndicatorView") new];
    
    [[visualEffectView contentView] addSubview:activityIndicatorView];
    [activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSClassFromString(@"NSLayoutConstraint") activateConstraints:@[
        [[activityIndicatorView topAnchor] constraintEqualToAnchor:[[visualEffectView contentView] topAnchor] constant:10.0f],
        [[activityIndicatorView leadingAnchor] constraintEqualToAnchor:[[visualEffectView contentView] leadingAnchor] constant:10.0f],
        [[activityIndicatorView trailingAnchor] constraintEqualToAnchor:[[visualEffectView contentView] trailingAnchor] constant:-10.0f],
        [[activityIndicatorView bottomAnchor] constraintEqualToAnchor:[[visualEffectView contentView] bottomAnchor] constant:-10.0f]
    ]];
    
    [activityIndicatorView setAnimating:YES skipBeginOrEndAnimations:YES];
    [self registerAssociatedObjectToVisualEffectView:visualEffectView];
    
    //
    
    [NSClassFromString(@"CATransaction") begin];
    
    id fade = [NSClassFromString(@"CABasicAnimation") animationWithKeyPath:@"opacity"];
    [fade setDuration:0.3f];
    [fade setFromValue:[NSNumber numberWithFloat:0.0f]];
    [fade setToValue:[NSNumber numberWithFloat:1.0f]];
    [fade setRemovedOnCompletion:YES];
    
    [[visualEffectView layer] addAnimation:fade forKey:@"fade"];
    
    [NSClassFromString(@"CATransaction") commit];
    
    //
    
    [visualEffectView release];
    [activityIndicatorView release];
}

- (void)removeActivityIndicatorViewFromView:(id)view superviewIfNeeded:(BOOL)superviewIfNeeded {
    void (^remove)(id _Nullable) = ^(id _Nullable view) {
        if (view) {
            [NSClassFromString(@"CATransaction") begin];
            
            [NSClassFromString(@"CATransaction") setCompletionBlock:^{
                [view removeFromSuperview];
                objc_removeAssociatedObjects(view);
            }];
            
            id fade = [NSClassFromString(@"CABasicAnimation") animationWithKeyPath:@"opacity"];
            [fade setDuration:0.3f];
            [fade setFromValue:[NSNumber numberWithFloat:1.0f]];
            [fade setToValue:[NSNumber numberWithFloat:0.0f]];
            [fade setRemovedOnCompletion:YES];
            
            [[view layer] addAnimation:fade forKey:@"fade"];
            
            [NSClassFromString(@"CATransaction") commit];
        }
    };
    
    if (superviewIfNeeded) {
        id targetView;
        
        if (superviewIfNeeded && [view superview]) {
            targetView = [view superview];
        } else {
            targetView = view;
        }
        
        remove([self visualEffectViewFromView:targetView]);
    }
    
    remove([self visualEffectViewFromView:view]);
}

- (id _Nullable)visualEffectViewFromView:(id)view {
    id _Nullable __block result = nil;
    
    [(NSArray *)[view subviews] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UIVisualEffectView")] && [self isAssociatedObjectWithtVisualEffectView:obj]) {
            result = obj;
            *stop = YES;
        }
    }];
    
    return result;
}

- (void)registerAssociatedObjectToVisualEffectView:(id)visualEffectView {
    objc_setAssociatedObject(visualEffectView, &ActivityIndicatorServiceVisualEffectViewItemKey, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isAssociatedObjectWithtVisualEffectView:(id)visualEffectView {
    NSNumber *isAssociatedObject = objc_getAssociatedObject(visualEffectView, &ActivityIndicatorServiceVisualEffectViewItemKey);
    
    if (isAssociatedObject == NULL) {
        return NO;
    }
    
    return isAssociatedObject.boolValue;
}

@end
