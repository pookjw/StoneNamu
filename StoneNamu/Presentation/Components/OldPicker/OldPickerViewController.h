//
//  OldPickerViewController.h
//  PickerSheetViewController
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import <UIKit/UIKit.h>
#import "OldPickerItemModel.h"

typedef void (^PickerViewControllerDoneCompletion)(OldPickerItemModel * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@interface OldPickerViewController : UIViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(NSArray<OldPickerItemModel *> *)dataSource
                             title:(NSString *)title
                      showEmptyRow:(BOOL)showEmptyRow
                    doneCompletion:(PickerViewControllerDoneCompletion)doneCompletion;
- (void)selectIdentity:(NSString *)identity animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
