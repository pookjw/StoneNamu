//
//  DecksViewModel.h
//  DecksViewModel
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "DecksSectionModel.h"
#import "DecksItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNameDecksViewModelShouldUpdateOptions = @"NSNotificationNameDecksViewModelShouldUpdateOptions";
static NSString * const DecksViewModelShouldUpdateOptionsSlugsAndNamesItemKey = @"DecksViewModelShouldUpdateOptionsSlugsAndNamesItemKey";
static NSString * const DecksViewModelShouldUpdateOptionsSlugsAndIdsItemKey = @"DecksViewModelShouldUpdateOptionsSlugsAndIdsItemKey";

static NSNotificationName const NSNotificationNameDecksViewModelStartedLoadingDataSource = @"NSNotificationNameDecksViewModelStartedLoadingDataSource";
static NSNotificationName const NSNotificationNameDecksViewModelEndedLoadingDataSource = @"NSNotificationNameDecksViewModelEndedLoadingDataSource";

typedef void (^DecksViewModelFetchDeckCodeCompletion)(LocalDeck * _Nullable, HSDeck * _Nullable, NSError * _Nullable);
typedef void (^DecksViewModelMakeLocalDeckCompletion)(LocalDeck *);
typedef void (^DecksViewModelParseClipboardCompletion)(NSString * _Nullable, NSString * _Nullable);
typedef void (^DecksViewModelLocalDecksFromIndexPathsCompletion)(NSSet<LocalDeck *> *localDecks);

typedef UICollectionViewDiffableDataSource<DecksSectionModel *, DecksItemModel *> DecksDataSource;

@interface DecksViewModel : NSObject
@property (retain) DecksDataSource *dataSource;
@property (retain) NSIndexPath * _Nullable contextMenuIndexPath;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(DecksDataSource *)dataSource;
- (void)requestDataSource;
- (void)requestOptions;
- (void)fetchDeckCode:(NSString *)deckCode title:(NSString * _Nullable)title completion:(DecksViewModelFetchDeckCodeCompletion)completion;
- (void)makeLocalDeckWithClassSlug:(NSString *)classSlug deckFormat:(HSDeckFormat)deckFormat completion:(DecksViewModelMakeLocalDeckCompletion)completion;
- (void)deleteLocalDecksFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths;
- (void)parseClipboardForDeckCodeWithCompletion:(DecksViewModelParseClipboardCompletion)completion;
- (void)localDecksFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths completion:(DecksViewModelLocalDecksFromIndexPathsCompletion)completion;
- (NSIndexPath * _Nullable)indexPathForLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
