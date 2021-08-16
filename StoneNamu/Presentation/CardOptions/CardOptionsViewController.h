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
@property (weak) id<CardOptionsViewControllerDelegate> delegate;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSString *> *)options;
- (void)setCancelButtonHidden:(BOOL)hidden;
@end
NS_ASSUME_NONNULL_END
