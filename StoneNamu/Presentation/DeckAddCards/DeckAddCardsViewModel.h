//
//  DeckAddCardsViewModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>
#import "DeckAddCardSectionModel.h"
#import "DeckAddCardItemModel.h"
#import "LocalDeck.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const DeckAddCardsViewModelErrorNotificationName = @"DeckAddCardsViewModelErrorNotificationName";
static NSString * const DeckAddCardsViewModelErrorNotificationErrorKey = @"DeckAddCardsViewModelErrorNotificationErrorKey";

static NSString * const DeckAddCardsViewModelPresentDetailNotificationName = @"DeckAddCardsViewModelPresentDetailNotificationName";
static NSString * const DeckAddCardsViewModelPresentDetailNotificationHSCardKey = @"DeckAddCardsViewModelPresentDetailNotificationHSCardKey";
static NSString * const DeckAddCardsViewModelPresentDetailNotificationIndexPathKey = @"DeckAddCardsViewModelPresentDetailNotificationIndexPathKey";

static NSString * const DeckAddCardsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName = @"DeckAddCardsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName";

typedef UICollectionViewDiffableDataSource<DeckAddCardSectionModel *, DeckAddCardItemModel *> CardsDataSource;

@interface DeckAddCardsViewModel : NSObject
@property (retain) LocalDeck * _Nullable localDeck;
@property (retain) NSIndexPath * _Nullable contextMenuIndexPath;
@property (readonly, retain) CardsDataSource *dataSource;
@property (readonly, copy) NSDictionary<NSString *, id> * _Nullable options;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardsDataSource *)dataSource;
- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *,id> * _Nullable)options reset:(BOOL)reset;
- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath;
- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath image:(UIImage * _Nullable)image;
- (void)addHSCards:(NSArray<HSCard *> *)hsCards;
@end

NS_ASSUME_NONNULL_END
