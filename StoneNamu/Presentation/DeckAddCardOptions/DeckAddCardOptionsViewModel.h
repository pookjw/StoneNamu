//
//  DeckAddCardOptionsViewModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>
#import "DeckAddCardOptionSectionModel.h"
#import "DeckAddCardOptionItemModel.h"
#import "PickerItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const DeckAddCardOptionsViewModelPresentTextFieldNotificationName = @"DeckAddCardOptionsViewModelPresentTextFieldNotificationName";
static NSString * const DeckAddCardOptionsViewModelPresentPickerNotificationName = @"DeckAddCardOptionsViewModelPresentPickerNotificationName";
static NSString * const DeckAddCardOptionsViewModelPresentStepperNotificationName = @"DeckAddCardOptionsViewModelPresentStepperNotificationName";
static NSString * const DeckAddCardOptionsViewModelPresentNotificationItemKey = @"DeckAddCardOptionsViewModelPresentNotificationItemKey";
static NSString * const DeckAddCardOptionsViewModelPresentPickerNotificationShowEmptyRowKey = @"DeckAddCardOptionsViewModelPresentPickerNotificationShowEmptyRowKey";

typedef UICollectionViewDiffableDataSource<DeckAddCardOptionSectionModel *, DeckAddCardOptionItemModel *> CardOptionsDataSource;

@interface DeckAddCardOptionsViewModel : NSObject
@property (readonly, retain) CardOptionsDataSource *dataSource;
@property (readonly, nonatomic) NSDictionary<NSString *, NSString *> *options;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource;
- (void)updateDataSourceWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options;
- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath;
- (void)updateItem:(DeckAddCardOptionItemModel *)itemModel withValue:(NSString * _Nullable)value;
@end

NS_ASSUME_NONNULL_END
