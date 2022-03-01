//
//  CardDetailsViewModel.h
//  CardDetailsViewModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "CardDetailsSectionModel.h"
#import "CardDetailsItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNameCardDetailsViewModelStartedLoadingDataSource = @"NSNotificationNameCardDetailsViewModelStartedLoadingDataSource";
static NSNotificationName const NSNotificationNameCardDetailsViewModelEndedLoadingDataSource = @"NSNotificationNameCardDetailsViewModelEndedLoadingDataSource";

typedef void (^CardDetailsViewModelRequestRecommendedImageURLCompletion)(NSURL * _Nullable url);

typedef UICollectionViewDiffableDataSource<CardDetailsSectionModel *, CardDetailsItemModel *> CardDetailsDataSource;

@interface CardDetailsViewModel : NSObject
@property (readonly, copy) HSCard * _Nullable hsCard;
@property (copy) HSCardGameModeSlugType _Nullable hsCardGameModeSlugType;
@property BOOL isGold;
@property (readonly, retain) CardDetailsDataSource *dataSource;
@property (copy) NSIndexPath * _Nullable contextMenuIndexPath;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardDetailsDataSource *)dataSource;
- (void)requestDataSourceWithCard:(HSCard *)hsCard;
- (void)requestRecommendedImageURLWithCompletion:(CardDetailsViewModelRequestRecommendedImageURLCompletion)completion;
- (NSArray<UIDragItem *> *)makeDragItemFromImage:(UIImage * _Nullable)image indexPath:(NSIndexPath * _Nullable)indexPath;
@end

NS_ASSUME_NONNULL_END
