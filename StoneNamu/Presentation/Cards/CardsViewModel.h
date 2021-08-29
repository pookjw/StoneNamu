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

static NSString * const CardsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName = @"CardsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName";

typedef UICollectionViewDiffableDataSource<CardSectionModel *, CardItemModel *> CardsDataSource;

@interface CardsViewModel : NSObject
@property (retain) NSIndexPath * _Nullable contextMenuIndexPath;
@property (readonly, retain) CardsDataSource *dataSource;
@property (copy) NSDictionary<NSString *, id> * _Nullable options;
- (instancetype)initWithDataSource:(CardsDataSource *)dataSource;
- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *,id> * _Nullable)options reset:(BOOL)reset;
- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath;
- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath image:(UIImage * _Nullable)image;
@end

NS_ASSUME_NONNULL_END
