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

static NSString * const CardOptionsViewModelPresentTextFieldNotificationName = @"CardOptionsViewModelPresentTextFieldNotificationName";
static NSString * const CardOptionsViewModelPresentPickerNotificationName = @"CardOptionsViewModelPresentPickerNotificationName";
static NSString * const CardOptionsViewModelPresentStepperNotificationName = @"CardOptionsViewModelPresentStepperNotificationName";
static NSString * const CardOptionsViewModelNotificationItemKey = @"CardOptionsViewModelNotificationItemKey";
static NSString * const CardOptionsViewModelPickerShowEmptyRowNotificationItemKey = @"CardOptionsViewModelPickerShowEmptyRowNotificationItemKey";

typedef UICollectionViewDiffableDataSource<CardOptionSectionModel *, CardOptionItemModel *> CardOptionsDataSource;

@interface CardOptionsViewModel : NSObject
@property (readonly, retain) CardOptionsDataSource *dataSource;
@property (readonly, nonatomic) NSDictionary<NSString *, id> *options;
- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource;
- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath;
- (void)updateItem:(CardOptionItemModel *)itemModel withValue:(NSString * _Nullable)value;
@end

NS_ASSUME_NONNULL_END
