//
//  CardDetailsViewModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "CardDetailsSectionModel.h"
#import "CardDetailsItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSCollectionViewDiffableDataSource<CardDetailsSectionModel *, CardDetailsItemModel *> CardDetailsDataSource;
typedef void (^CardDetailsViewModelHSCardsFromIndexPathsCompletion)(NSSet<HSCard *> *hsCards);
typedef void (^CardDetailsViewModelPhotoServiceModelsFromIndexPathsCompletion)(NSSet<HSCard *> *hsCards, NSDictionary<HSCard *, HSCardGameModeSlugType> *hsCardGameModeSlugTypes, NSDictionary<HSCard *, NSNumber *> *isGolds);
typedef void (^CardDetailsViewModelItemModelsFromIndexPathsCompletion)(NSSet<CardDetailsItemModel *> * itemModels);

static NSNotificationName const NSNotificationNameCardDetailsViewModelStartedLoadingDataSource = @"NSNotificationNameCardDetailsViewModelStartedLoadingDataSource";
static NSNotificationName const NSNotificationNameCardDetailsViewModelEndedLoadingDataSource = @"NSNotificationNameCardDetailsViewModelEndedLoadingDataSource";

@interface CardDetailsViewModel : NSObject
@property (readonly, copy) HSCard * _Nullable hsCard;
@property (readonly, copy) HSCardGameModeSlugType _Nullable hsCardGameModeSlugType;
@property (readonly) BOOL isGold;
@property (readonly, retain) CardDetailsDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardDetailsDataSource *)dataSource;
- (void)requestDataSourceWithCard:(HSCard *)hsCard hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold;
- (NSSet<HSCard *> *)hsCardsFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths;
- (void)itemModelsFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths completion:(CardDetailsViewModelItemModelsFromIndexPathsCompletion)completion;
- (void)photoServiceModelsFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths completion:(CardDetailsViewModelPhotoServiceModelsFromIndexPathsCompletion)completion;
@end

NS_ASSUME_NONNULL_END
