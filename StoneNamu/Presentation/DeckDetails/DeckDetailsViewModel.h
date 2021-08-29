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

static NSString * const DeckDetailsViewModelHasAnyCardsNotificationName = @"DeckDetailsViewModelHasAnyCardsNotificationName";
static NSString * const DeckDetailsViewModelHasAnyCardsItemKey = @"DeckDetailsViewModelHasAnyCardsItemKey";

static NSString * const DeckDetailsViewModelDidChangeLocalDeckNameNoficationName = @"DeckDetailsViewModelDidChangeLocalDeckNameNoficationName";
static NSString * const DeckDetailsViewModelDidChangeLocalDeckNameItemKey = @"DeckDetailsViewModelDidChangeLocalDeckNameItemKey";

static NSString * const DeckDetailsViewModelErrorOccuredNoficiationName = @"DeckDetailsViewModelErrorOccuredNoficiationName";
static NSString * const DeckDetailsViewModelErrorOccuredItemKey = @"DeckDetailsViewModelErrorOccuredItemKey";

@interface DeckDetailsViewModel : NSObject
@property (retain) NSIndexPath * _Nullable contextMenuIndexPath;
@property (readonly, retain) LocalDeck *localDeck;
@property (readonly, retain) DecksDetailsDataSource *dataSource;
- (instancetype)initWithDataSource:(DecksDetailsDataSource *)dataSource;
- (void)requestDataSourcdWithLocalDeck:(LocalDeck *)localDeck;
- (void)addHSCards:(NSArray<HSCard *> *)hsCards;

- (void)increaseAtIndexPath:(NSIndexPath *)indexPath;
- (void)decreaseAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath;
- (void)exportDeckCodeWithCompletion:(DeckDetailsViewModelExportDeckCodeCompletion)completion;
- (void)updateDeckName:(NSString *)name;
- (NSString * _Nullable)headerTextForIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
