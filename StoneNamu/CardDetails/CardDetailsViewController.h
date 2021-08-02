//
//  CardDetailsViewController.h
//  CardDetailsViewController
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <UIKit/UIKit.h>
#import "CardDetailsViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsViewController : UIViewController
@property (assign) id<CardDetailsViewControllerDelegate> delegate;
- (instancetype)initWithCardImageView:(UIImageView *)cardImageView;
@end

NS_ASSUME_NONNULL_END
