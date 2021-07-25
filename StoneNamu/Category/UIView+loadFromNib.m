//
//  UIView+loadFromNib.m
//  UIView+loadFromNib
//
//  Created by Jinwoo Kim on 7/26/21.
//

#import "UIView+loadFromNib.h"

@implementation UIView (loadFromNib)

+ (instancetype)loadFromNib {
    id loadedView = [[NSBundle.mainBundle loadNibNamed:NSStringFromClass([self class])
                                                                         owner:nil
                                                                         options:nil]
                     firstObject];
    return loadedView;
}

@end
