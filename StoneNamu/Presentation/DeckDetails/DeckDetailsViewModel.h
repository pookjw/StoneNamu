//
//  DeckDetailsViewModel.h
//  DeckDetailsViewModel
//
//  Created by Jinwoo Kim on 8/20/21.
//

#import <UIKit/UIKit.h>
#import "LocalDeck.h"
#import "DeckDetailsSectionModel.h"
#import "DeckDetailsItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef UICollectionViewDiffableDataSource<DeckDetailsSectionModel *, DeckDetailsItemModel *> DecksDetailsDataSource;

typedef void (^DeckDetailsViewModelExportDeckCodeCompletion)(NSString * _Nullable);

static NSString * const DeckDetailsViewModelShouldDismissNotificationName = @"DeckDetailsViewModelShouldDismissNotificationName";
static NSString * const DeckDetailsViewModelDidChangeLocalDeckNameNoficationName = @"DeckDetailsViewModelDidChangeLocalDeckNameNoficationName";
static NSString * const DeckDetailsViewModelDidChangeLocalDeckNameItemKey = @"DeckDetailsViewModelDidChangeLocalDeckNameItemKey";

static NSString * const DeckDetailsViewModelErrorOccurredNoficiationName = @"DeckDetailsViewModelErrorOccurredNoficiationName";
static NSString * const DeckDetailsViewModelErrorOccurredItemKey = @"DeckDetailsViewModelErrorOccurredItemKey";

static NSString * const DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName = @"DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName";
static NSString * const DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneHasAnyCardsItemKey = @"DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneHasAnyCardsItemKey";
static NSString * const DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneCardsHeaderTextKey = @"DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneCardsHeaderTextKey";

@interface DeckDetailsViewModel : NSObject
@property (retain) NSIndexPath * _Nullable contextMenuIndexPath;
@property (readonly, retain) LocalDeck * _Nullable localDeck;
@property (readonly, retain) DecksDetailsDataSource *dataSource;
@property BOOL shouldPresentDeckEditor;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(DecksDetailsDataSource *)dataSource;
- (void)requestDataSourceWithLocalDeck:(LocalDeck *)localDeck;
- (void)addHSCards:(NSArray<HSCard *> *)hsCards;

- (void)increaseAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)decreaseAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath;
- (void)exportLocalizedDeckCodeWithCompletion:(DeckDetailsViewModelExportDeckCodeCompletion)completion;
- (void)updateDeckName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
