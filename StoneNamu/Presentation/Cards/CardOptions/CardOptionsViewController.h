//
//  CardOptionsViewController.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>
#import "CardOptionsViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardOptionsViewController : UIViewController
@property (assign) id<CardOptionsViewControllerDelegate> delegate;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options;
- (void)setCancelButtonHidden:(BOOL)hidden;
@end
NS_ASSUME_NONNULL_END
