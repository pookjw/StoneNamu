//
//  DeckDetailsViewModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import <Cocoa/Cocoa.h>
#import "DeckDetailsSectionModel.h"
#import "DeckDetailsItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSCollectionViewDiffableDataSource<DeckDetailsSectionModel *, DeckDetailsItemModel *> DeckDetailsDataSource;

typedef void (^DeckDetailsViewModelLoadFromRIRepresentationCompletion)(BOOL result);
typedef void (^DeckDetailsViewModelExportDeckCodeCompletion)(NSString * _Nullable);
typedef void (^DeckDetailsViewModelHSCardsFromIndexPathsCompletion)(NSSet<HSCard *> *);

static NSNotificationName const NSNotificationNameDeckDetailsViewModelShouldDismiss = @"NSNotificationNameDeckDetailsViewModelShouldDismiss";
static NSNotificationName const NSNotificationNameDeckDetailsViewModelDidChangeLocalDeck = @"NSNotificationNameDeckDetailsViewModelDidChangeLocalDeck";
static NSString * const DeckDetailsViewModelDidChangeLocalDeckNameItemKey = @"DeckDetailsViewModelDidChangeLocalDeckNameItemKey";

static NSNotificationName const NSNotificationNameDeckDetailsViewModelErrorOccurred = @"NSNotificationNameDeckDetailsViewModelErrorOccurred";
static NSString * const DeckDetailsViewModelErrorOccurredItemKey = @"DeckDetailsViewModelErrorOccurredItemKey";

static NSNotificationName const NSNotificationNameDeckDetailsViewModelApplyingSnapshotToDataSourceWasDone = @"NSNotificationNameDeckDetailsViewModelApplyingSnapshotToDataSourceWasDone";
static NSString * const DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneHasAnyCardsItemKey = @"DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneHasAnyCardsItemKey";
static NSString * const DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneManaGraphDatasKey = @"DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneManaGraphDatasKey";

static NSNotificationName const NSNotificationNameDeckDetailsViewModelShouldChangeWindowSubtitle = @"NSNotificationNameDeckDetailsViewModelShouldChangeWindowSubtitle";
static NSString * const DeckDetailsViewModelShouldChangeWindowSubtitleTextKey = @"DeckDetailsViewModelShouldChangeWindowSubTitleTextKey";

@interface DeckDetailsViewModel : NSObject
@property (readonly, retain) LocalDeck * _Nullable localDeck;
@property (readonly, retain) DeckDetailsDataSource *dataSource;
@property (readonly, retain) NSString * _Nullable windowSubtitle;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(DeckDetailsDataSource *)dataSource;
- (void)requestDataSourceFromURIRepresentation:(NSURL *)URIRepresentation completion:(DeckDetailsViewModelLoadFromRIRepresentationCompletion)completion;
- (void)requestDataSourceFromLocalDeck:(LocalDeck *)localDeck;
- (void)addHSCards:(NSArray<HSCard *> *)hsCards;
- (void)addHSCardsWithDatas:(NSArray<NSData *> *)datas;

- (void)increaseAtIndexPath:(NSIndexPath *)indexPath;
- (void)decreaseAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteAtIndexPathes:(NSSet<NSIndexPath *> *)indexPathes;
- (void)deleteLocalDeck;

- (void)exportLocalizedDeckCodeWithCompletion:(DeckDetailsViewModelExportDeckCodeCompletion)completion;
- (void)updateDeckName:(NSString *)name;

- (NSSet<HSCard *> *)hsCardsFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths;
- (void)hsCardsFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths completion:(DeckDetailsViewModelHSCardsFromIndexPathsCompletion)completion;
@end

NS_ASSUME_NONNULL_END
