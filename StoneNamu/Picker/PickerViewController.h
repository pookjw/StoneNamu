//
//  PickerViewController.h
//  PickerSheetViewController
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import <UIKit/UIKit.h>
#import "PickerItemModel.h"

typedef void (^PickerViewControllerDoneCompletion)(PickerItemModel * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@interface PickerViewController : UIViewController
- (instancetype)initWithDataSource:(NSArray<PickerItemModel *> *)dataSource title:(NSString *)title showEmptyRow:(BOOL)showEmptyRow doneCompletion:(PickerViewControllerDoneCompletion)doneCompletion;
- (void)selectIdentity:(NSString *)identity animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
