//
//  CardOptionsViewModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>
#import "CardOptionSectionModel.h"
#import "CardOptionItemModel.h"
#import "PickerItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNameCardOptionsViewModelPresentTextField = @"NSNotificationNameCardOptionsViewModelPresentTextField";
static NSString * CardOptionsViewModelPresentTextFieldOptionTypeItemKey = @"CardOptionsViewModelPresentTextFieldOptionTypeItemKey";
static NSString * CardOptionsViewModelPresentTextFieldTextItemKey = @"CardOptionsViewModelPresentTextFieldTextItemKey";

static NSNotificationName const NSNotificationNameCardOptionsViewModelPresentPicker = @"NSNotificationNameCardOptionsViewModelPresentPicker";
static NSString * CardOptionsViewModelPresentPickerNotificationOptionTypeItemKey = @"CardOptionsViewModelPresentPickerNotificationOptionTypeItemKey";
static NSString * const CardOptionsViewModelPresentPickerNotificationValuesItemKey = @"CardOptionsViewModelPresentPickerNotificationValuesItemKey";
static NSString * const CardOptionsViewModelPresentPickerNotificationShowEmptyRowItemKey = @"CardOptionsViewModelPresentPickerNotificationShowEmptyRowItemKey";

typedef UICollectionViewDiffableDataSource<CardOptionSectionModel *, CardOptionItemModel *> CardOptionsDataSource;

@interface CardOptionsViewModel : NSObject
@property (readonly, retain) CardOptionsDataSource *dataSource;
@property (readonly, nonatomic) NSDictionary<NSString *, NSSet<NSString *> *> *options;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource;
- (void)updateDataSourceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath;
- (void)updateOptionType:(BlizzardHSAPIOptionType)optionType withValues:(NSSet<NSString *> * _Nullable)values;
@end

NS_ASSUME_NONNULL_END
