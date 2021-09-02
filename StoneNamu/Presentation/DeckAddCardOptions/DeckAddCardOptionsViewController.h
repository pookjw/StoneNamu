//
//  DeckAddCardOptionsViewController.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>
#import "DeckAddCardOptionsViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardOptionsViewController : UIViewController
@property (weak) id<DeckAddCardOptionsViewControllerDelegate> delegate;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options;
- (void)setCancelButtonHidden:(BOOL)hidden;
@end
NS_ASSUME_NONNULL_END
