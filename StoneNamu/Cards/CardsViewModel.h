//
//  CardsViewModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>
#import "CardSectionModel.h"
#import "CardItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const CardsViewModelErrorNotificationName = @"CardsViewModelErrorNotificationName";
static NSString * const CardsViewModelErrorNotificationErrorKey = @"CardsViewModelErrorNotificationErrorKey";

static NSString * const CardsViewModelPresentDetailNotificationName = @"CardsViewModelPresentDetailNotificationName";
static NSString * const CardsViewModelPresentDetailNotificationHSCardKey = @"CardsViewModelPresentDetailNotificationHSCardKey";
static NSString * const CardsViewModelPresentDetailNotificationIndexPathKey = @"CardsViewModelPresentDetailNotificationIndexPathKey";

typedef UICollectionViewDiffableDataSource<CardSectionModel *, CardItemModel *> CardsDataSource;

@interface CardsViewModel : NSObject
@property (readonly, retain) CardsDataSource *dataSource;
- (instancetype)initWithDataSource:(CardsDataSource *)dataSource;
- (void)requestDataSourceWithOptions:(NSDictionary<NSString *,id> * _Nullable)options;
- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
