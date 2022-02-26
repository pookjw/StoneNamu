//
//  BattlegroundsCardOptionsViewModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/26/22.
//

#import <UIKit/UIKit.h>
#import "BattlegroundsCardOptionSectionModel.h"
#import "BattlegroundsCardOptionItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNameBattlegroundsCardOptionsViewModelPresentTextField = @"NSNotificationNameBattlegroundsCardOptionsViewModelPresentTextField";
static NSString * BattlegroundsCardOptionsViewModelPresentTextFieldOptionTypeItemKey = @"BattlegroundsCardOptionsViewModelPresentTextFieldOptionTypeItemKey";
static NSString * BattlegroundsCardOptionsViewModelPresentTextFieldTextItemKey = @"BattlegroundsCardOptionsViewModelPresentTextFieldTextItemKey";
static NSString * BattlegroundsCardOptionsViewModelPresentTextFieldIndexPathItemKey = @"BattlegroundsCardOptionsViewModelPresentTextFieldIndexPathItemKey";

static NSNotificationName const NSNotificationNameBattlegroundsCardOptionsViewModelPresentPicker = @"NSNotificationNameBattlegroundsCardOptionsViewModelPresentPicker";
static NSString * const BattlegroundsCardOptionsViewModelPresentPickerNotificationTitleItemKey = @"BattlegroundsCardOptionsViewModelPresentPickerNotificationTitleItemKey";
static NSString * const BattlegroundsCardOptionsViewModelPresentPickerNotificationOptionTypeItemKey = @"BattlegroundsCardOptionsViewModelPresentPickerNotificationOptionTypeItemKey";
static NSString * const BattlegroundsCardOptionsViewModelPresentPickerNotificationPickersItemKey = @"BattlegroundsCardOptionsViewModelPresentPickerNotificationPickersItemKey";
static NSString * const BattlegroundsCardOptionsViewModelPresentPickerNotificationAllowsMultipleSelectionItemKey = @"BattlegroundsCardOptionsViewModelPresentPickerNotificationAllowsMultipleSelectionItemKey";
static NSString * const BattlegroundsCardOptionsViewModelPresentPickerNotificationComparatorItemKey = @"BattlegroundsCardOptionsViewModelPresentPickerNotificationComparatorItemKey";

static NSNotificationName const NSNotificationNameBattlegroundsCardOptionsViewModelStartedLoadingDataSource = @"NSNotificationNameBattlegroundsBattlegroundsCardOptionsViewModelStartedLoadingDataSource";
static NSNotificationName const NSNotificationNameBattlegroundsCardOptionsViewModelEndedLoadingDataSource = @"NSNotificationNameBattlegroundsCardOptionsViewModelEndedLoadingDataSource";

static NSNotificationName const NSNotificationNameBattlegroundsCardOptionsViewModelErrorOccured = @"NSNotificationNameBattlegroundsCardOptionsViewModelErrorOccured";
static NSString * const BattlegroundsCardOptionsViewModelErrorOccuredErrorItemKey = @"BattlegroundsCardOptionsViewModelErrorOccuredErrorItemKey";

typedef UICollectionViewDiffableDataSource<BattlegroundsCardOptionSectionModel *, BattlegroundsCardOptionItemModel *> BattlegroundsCardOptionsDataSource;

@interface BattlegroundsCardOptionsViewModel : NSObject
@property (copy) NSIndexPath * _Nullable contextMenuIndexPath;
@property (readonly, retain) BattlegroundsCardOptionsDataSource *dataSource;
@property (readonly, nonatomic) NSDictionary<NSString *, NSSet<NSString *> *> *options;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(BattlegroundsCardOptionsDataSource *)dataSource;
- (void)updateDataSourceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath;
- (void)updateOptionType:(BlizzardHSAPIOptionType)optionType withValues:(NSSet<NSString *> * _Nullable)values;
@end

NS_ASSUME_NONNULL_END
