//
//  UIView+floatingConstraints.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 10/18/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (floatingConstraints)
@property (copy, nonatomic) NSArray<NSLayoutConstraint *> * _Nullable floatingConstraints;
@end

NS_ASSUME_NONNULL_END
