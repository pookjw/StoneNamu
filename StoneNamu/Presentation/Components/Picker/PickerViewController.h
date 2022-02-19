//
//  PickerViewController.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import <UIKit/UIKit.h>
#import "PickerItemModel.h"
#import "PickerViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^PickerViewControllerDidSelectItems)(NSSet<PickerItemModel *> *);

@interface PickerViewController : UIViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithItems:(NSSet<PickerItemModel *> *)items allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator delegate:(id<PickerViewControllerDelegate>)delegate;
- (instancetype)initWithItems:(NSSet<PickerItemModel *> *)items allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator didSelectItems:(PickerViewControllerDidSelectItems)didSelectItems;
@end

NS_ASSUME_NONNULL_END
