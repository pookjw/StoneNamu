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

typedef UICollectionViewDiffableDataSource<CardOptionsSectionModel *, CardOptionsItemModel *> CardOptionsDataSource;

@interface CardOptionsViewModel : NSObject
@property (readonly, retain) CardOptionsDataSource *dataSource;
- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource;
- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
