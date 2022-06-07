//
//  UIImageView+setImage.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 6/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIImageView
@end

@interface UIImageView (Private)
- (void)setImage:(UIImage *)image;
@end
NS_ASSUME_NONNULL_END
