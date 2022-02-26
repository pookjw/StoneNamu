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

static NSNotificationName const NSNotificationNameCardsViewModelError = @"NSNotificationNameCardsViewModelError";
static NSString * const CardsViewModelErrorNotificationErrorKey = @"CardsViewModelErrorNotificationErrorKey";

static NSNotificationName const NSNotificationNameCardsViewModelStartedLoadingDataSource = @"NSNotificationNameCardsViewModelStartedLoadingDataSource";
static NSNotificationName const NSNotificationNameCardsViewModelEndedLoadingDataSource = @"NSNotificationNameCardsViewModelEndedLoadingDataSource";

typedef UICollectionViewDiffableDataSource<CardSectionModel *, CardItemModel *> CardsDataSource;

@interface CardsViewModel : NSObject
@property (copy) NSIndexPath * _Nullable contextMenuIndexPath;
@property (readonly, retain) CardsDataSource *dataSource;
@property (readonly, copy) NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable options;
@property (readonly, nonatomic) NSDictionary<NSString *, NSSet<NSString *> *> *defaultOptions;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardsDataSource *)dataSource;
- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options reset:(BOOL)reset;
- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath image:(UIImage * _Nullable)image;
@end

NS_ASSUME_NONNULL_END
