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
@property (readonly, copy) NSDictionary<NSString *, NSString *> * _Nullable options;
- (void)requestWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options;
- (void)setOptionsBarButtonItemHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
