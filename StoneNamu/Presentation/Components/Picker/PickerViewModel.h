//
//  PickerViewModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import <UIKit/UIkit.h>
#import "PickerSectionModel.h"
#import "PickerItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNamePickerViewModelEndedLoadingDataSource = @"NSNotificationNamePickerViewModelEndedLoadingDataSource";
static NSString * PickerViewModelEndedLoadingDataSourceItemsKey = @"PickerViewModelEndedLoadingDataSourceItemsKey";

typedef UICollectionViewDiffableDataSource<PickerSectionModel *, PickerItemModel *> PickerDataSource;

@interface PickerViewModel : NSObject
@property (readonly, retain) PickerDataSource *dataSource;
@property BOOL allowsMultipleSelection;
@property (copy, nullable) NSComparisonResult (^comparator)(NSString *, NSString *);
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(PickerDataSource *)dataSource;
- (void)updateDataSourceWithItems:(NSDictionary<PickerSectionModel *, NSSet<PickerItemModel *> *> *)items;
- (void)handleSelectionAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
