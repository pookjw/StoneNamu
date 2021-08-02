//
//  CardDetailsViewControllerDelegate.h
//  CardDetailsViewControllerDelegate
//
//  Created by Jinwoo Kim on 8/3/21.
//

#import <UIKit/UIKit.h>

@class CardDetailsViewController;

@protocol CardDetailsViewControllerDelegate <NSObject>
- (void)cardDetailsViewControllerDidDismiss:(CardDetailsViewController *)viewController cardImageView:(UIImageView *)cardImageView;
@end
