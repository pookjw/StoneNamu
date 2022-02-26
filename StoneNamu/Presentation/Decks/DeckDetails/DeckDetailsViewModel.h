//
//  DeckDetailsViewModel.h
//  DeckDetailsViewModel
//
//  Created by Jinwoo Kim on 8/20/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "DeckDetailsSectionModel.h"
#import "DeckDetailsItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef UICollectionViewDiffableDataSource<DeckDetailsSectionModel *, DeckDetailsItemModel *> DeckDetailsDataSource;

typedef void (^DeckDetailsViewModelExportDeckCodeCompletion)(NSString * _Nullable);

static NSNotificationName const NSNotificationNameDeckDetailsViewModelShouldDismiss = @"NSNotificationNameDeckDetailsViewModelShouldDismiss";
static NSNotificationName const NSNotificationNameDeckDetailsViewModelDidChangeLocalDeck = @"NSNotificationNameDeckDetailsViewModelDidChangeLocalDeck";
static NSString * const DeckDetailsViewModelDidChangeLocalDeckNameItemKey = @"DeckDetailsViewModelDidChangeLocalDeckNameItemKey";

static NSNotificationName const NSNotificationNameDeckDetailsViewModelErrorOccurred = @"NSNotificationNameDeckDetailsViewModelErrorOccurred";
static NSString * const DeckDetailsViewModelErrorOccurredItemKey = @"DeckDetailsViewModelErrorOccurredItemKey";

static NSNotificationName const NSNotificationNameDeckDetailsViewModelApplyingSnapshotToDataSourceWasDone = @"NSNotificationNameDeckDetailsViewModelApplyingSnapshotToDataSourceWasDone";
static NSString * const DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneHasAnyCardsItemKey = @"DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneHasAnyCardsItemKey";
static NSString * const DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneCardsHeaderTextKey = @"DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneCardsHeaderTextKey";

typedef void (^DeckDetailsViewModellHSCardFromIndexPathCompletion)(HSCard * _Nullable hsCard);

@interface DeckDetailsViewModel : NSObject
@property (copy) NSIndexPath * _Nullable contextMenuIndexPath;
@property (readonly, retain) LocalDeck * _Nullable localDeck;
@property (readonly, retain) DeckDetailsDataSource *dataSource;
@property BOOL shouldPresentDeckEditor;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(DeckDetailsDataSource *)dataSource;
- (void)requestDataSourceFromLocalDeck:(LocalDeck *)localDeck;
- (void)hsCardFromIndexPath:(NSIndexPath *)indexPath completion:(DeckDetailsViewModellHSCardFromIndexPathCompletion)completion;

- (void)addHSCards:(NSArray<HSCard *> *)hsCards;

- (void)increaseAtIndexPath:(NSIndexPath *)indexPath;
- (void)decreaseAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteAtIndexPathes:(NSSet<NSIndexPath *> *)indexPathes;

- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath;
- (void)exportLocalizedDeckCodeWithCompletion:(DeckDetailsViewModelExportDeckCodeCompletion)completion;
- (void)updateDeckName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
