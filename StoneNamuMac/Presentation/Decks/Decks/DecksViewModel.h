//
//  DecksViewModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "DecksSectionModel.h"
#import "DecksItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSCollectionViewDiffableDataSource<DecksSectionModel *, DecksItemModel *> DecksDataSource;

static NSNotificationName NSNotificationNameDecksViewModelApplyingSnapshotToDataSourceWasDone = @"NSNotificationNameDecksViewModelApplyingSnapshotToDataSourceWasDone";

typedef void (^DecksViewModelFetchDeckCodeCompletion)(LocalDeck * _Nullable, HSDeck * _Nullable, NSError * _Nullable);
typedef void (^DecksViewModelMakeLocalDeckCompletion)(LocalDeck *);
typedef void (^DecksViewModelParseClipboardCompletion)(NSString * _Nullable, NSString * _Nullable);
typedef void (^DecksViewModelLocalDecksFromIndexPathsCompletion)(NSSet<LocalDeck *> *localDecks);

@interface DecksViewModel : NSObject
@property (retain) DecksDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(DecksDataSource *)dataSource;
- (void)requestDataSource;
- (void)fetchDeckCode:(NSString *)deckCode title:(NSString * _Nullable)title completion:(DecksViewModelFetchDeckCodeCompletion)completion;
- (void)makeLocalDeckWithClass:(HSCardClass)hsCardClass deckFormat:(HSDeckFormat)deckFormat completion:(DecksViewModelMakeLocalDeckCompletion)completion;
- (void)deleteLocalDecksFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths;
- (void)updateDeckName:(NSString *)name forLocalDeck:(LocalDeck *)localDeck;
- (void)updateDeckName:(NSString *)name forIndexPath:(NSIndexPath *)indexPath;
- (void)parseClipboardForDeckCodeWithCompletion:(DecksViewModelParseClipboardCompletion)completion;
- (void)localDecksFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths completion:(DecksViewModelLocalDecksFromIndexPathsCompletion)completion;
@end

NS_ASSUME_NONNULL_END
