//
//  CardDetailsViewController.h
//  CardDetailsViewController
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <UIKit/UIKit.h>
#import "HSCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsViewController : UIViewController
- (instancetype)initWithHSCard:(HSCard *)hsCard sourceImageView:(UIImageView *)sourceImageView;
@end

NS_ASSUME_NONNULL_END