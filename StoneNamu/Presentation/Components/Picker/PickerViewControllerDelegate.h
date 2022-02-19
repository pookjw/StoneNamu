//
//  PickerViewControllerDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PickerViewController;
@class PickerItemModel;

@protocol PickerViewControllerDelegate <NSObject>
- (void)pickerViewController:(PickerViewController *)pickerViewController didSelectItems:(NSSet<PickerItemModel *> *)selectedItems;
@end

NS_ASSUME_NONNULL_END
