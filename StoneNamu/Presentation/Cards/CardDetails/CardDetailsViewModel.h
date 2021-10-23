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

static NSString * CardDetailsViewModelStartFetchingChildCardsNotificationName = @"CardDetailsViewModelStartFetchingChildCardsNotificationName";
static NSString * CardDetailsViewModelStartFetchedChildCardsNotificationName = @"CardDetailsViewModelStartFetchedChildCardsNotificationName";

typedef UICollectionViewDiffableDataSource<CardDetailsSectionModel *, CardDetailsItemModel *> CardDetailsDataSource;

@interface CardDetailsViewModel : NSObject
@property (readonly, copy) HSCard * _Nullable hsCard;
@property (readonly, retain) CardDetailsDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardDetailsDataSource *)dataSource;
- (void)requestDataSourceWithCard:(HSCard *)hsCard;
- (NSArray<UIDragItem *> *)makeDragItemFromImage:(UIImage * _Nullable)image;
@end

NS_ASSUME_NONNULL_END
