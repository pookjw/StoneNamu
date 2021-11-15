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
static NSNotificationName const NSNotificationNameCardOptionsViewModelPresentPicker = @"NSNotificationNameCardOptionsViewModelPresentPicker";
static NSNotificationName const NSNotificationNameCardOptionsViewModelPresentStepper = @"NSNotificationNameCardOptionsViewModelPresentStepper";
static NSString * const CardOptionsViewModelPresentNotificationItemKey = @"CardOptionsViewModelPresentNotificationItemKey";
static NSString * const CardOptionsViewModelPresentPickerNotificationShowEmptyRowKey = @"CardOptionsViewModelPresentPickerNotificationShowEmptyRowKey";

typedef UICollectionViewDiffableDataSource<CardOptionSectionModel *, CardOptionItemModel *> CardOptionsDataSource;

@interface CardOptionsViewModel : NSObject
@property (readonly, retain) CardOptionsDataSource *dataSource;
@property (readonly, nonatomic) NSDictionary<NSString *, NSString *> *options;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource;
- (void)updateDataSourceWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options;
- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath;
- (void)updateItem:(CardOptionItemModel *)itemModel withValue:(NSString * _Nullable)value;
@end

NS_ASSUME_NONNULL_END
