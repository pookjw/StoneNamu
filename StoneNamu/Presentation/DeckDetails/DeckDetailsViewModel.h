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

typedef void (^DeckDetailsViewModelExportDeckCodeCompletion)(NSString * _Nullable, NSError * _Nullable);

static NSString * const DeckDetailsViewModelShouldDismissNotificationName = @"DeckDetailsViewModelShouldDismissNotificationName";
static NSString * const DeckDetailsViewModelHasAnyCardsNotificationName = @"DeckDetailsViewModelHasAnyCardsNotificationName";
static NSString * const DeckDetailsViewModelHasAnyCardsItemKey = @"DeckDetailsViewModelHasAnyCardsItemKey";

@interface DeckDetailsViewModel : NSObject
@property (retain) DecksDetailsDataSource *dataSource;
- (instancetype)initWithDataSource:(DecksDetailsDataSource *)dataSource;
- (void)requestDataSourcdWithLocalDeck:(LocalDeck *)localDeck;
- (void)addHSCards:(NSArray<HSCard *> *)hsCards;
- (void)removeAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath;
- (void)exportDeckCodeWithCompletion:(DeckDetailsViewModelExportDeckCodeCompletion)completion;
@end

NS_ASSUME_NONNULL_END
