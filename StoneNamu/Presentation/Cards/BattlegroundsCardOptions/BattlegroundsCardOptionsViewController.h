//
//  BattlegroundsCardOptionsViewController.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/26/22.
//

#import <UIKit/UIKit.h>
#import "BattlegroundsCardOptionsViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface BattlegroundsCardOptionsViewController : UIViewController
@property (assign) id<BattlegroundsCardOptionsViewControllerDelegate> delegate;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
- (void)setCancelButtonHidden:(BOOL)hidden;
@end
NS_ASSUME_NONNULL_END
