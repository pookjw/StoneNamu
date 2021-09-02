//
//  CardsViewController.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/23/21.
//

#import <UIKit/UIKit.h>
#import "CardOptionsViewControllerDelegate.h"
#import "CardsViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardsViewController : UIViewController <UICollectionViewDelegate, CardOptionsViewControllerDelegate>
@property (readonly, retain) CardsViewModel *viewModel;
- (NSDictionary<NSString *, NSString *> * _Nullable)setOptionsBarButtonItemHidden:(BOOL)hidden;
- (void)requestDataSourceWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options;
@end

NS_ASSUME_NONNULL_END
