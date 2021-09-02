//
//  CardsViewController.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/23/21.
//

#import <UIKit/UIKit.h>
#import "CardOptionsViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardsViewController : UIViewController <CardOptionsViewControllerDelegate>
- (NSDictionary<NSString *, NSString *> * _Nullable)setOptionsBarButtonItemHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
