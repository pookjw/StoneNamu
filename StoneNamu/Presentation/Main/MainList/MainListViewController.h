//
//  MainListViewController.h
//  MainListViewController
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import <UIKit/UIKit.h>
#import "MainListItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainListViewController : UIViewController
- (void)setSelectionStatusForType:(MainListItemModelType)type;
@end

NS_ASSUME_NONNULL_END
