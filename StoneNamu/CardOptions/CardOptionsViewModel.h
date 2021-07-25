//
//  CardOptionsViewModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>
#import "CardOptionsSectionModel.h"
#import "CardOptionsItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const CardOptionsViewModelPresentTextFieldNotificationName = @"CardOptionsViewModelPresentTextFieldNotificationName";
static NSString * const CardOptionsViewModelPresentPickerNotificationName = @"CardOptionsViewModelPresentPickerNotificationName";
static NSString * const CardOptionsViewModelNotificationItemKey = @"item";

typedef UICollectionViewDiffableDataSource<CardOptionsSectionModel *, CardOptionsItemModel *> CardOptionsDataSource;

@interface CardOptionsViewModel : NSObject
@property (readonly, retain) CardOptionsDataSource *dataSource;
@property (readonly, nonatomic) NSDictionary<NSString *, id> *options;
- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource;
- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath;
- (void)updateItem:(CardOptionsItemModel *)itemModel withValue:(NSString * _Nullable)value;
@end

NS_ASSUME_NONNULL_END
