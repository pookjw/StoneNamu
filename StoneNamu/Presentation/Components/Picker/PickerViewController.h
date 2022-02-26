//
//  PickerViewController.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import <UIKit/UIKit.h>
#import "PickerSectionModel.h"
#import "PickerItemModel.h"
#import "PickerViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^PickerViewControllerDidSelectItems)(NSSet<PickerItemModel *> *);

@interface PickerViewController : UIViewController
- (instancetype)initWithItems:(NSDictionary<PickerSectionModel *, NSSet<PickerItemModel *> *> *)items allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator delegate:(id<PickerViewControllerDelegate>)delegate;
- (instancetype)initWithItems:(NSDictionary<PickerSectionModel *, NSSet<PickerItemModel *> *> *)items allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator didSelectItems:(PickerViewControllerDidSelectItems)didSelectItems;
- (void)requestWithItems:(NSDictionary<PickerSectionModel *, NSSet<PickerItemModel *> *> *)items allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator delegate:(id<PickerViewControllerDelegate>)delegate;
- (void)requestWithItems:(NSDictionary<PickerSectionModel *, NSSet<PickerItemModel *> *> *)items allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator didSelectItems:(PickerViewControllerDidSelectItems)didSelectItems;
@end

NS_ASSUME_NONNULL_END
