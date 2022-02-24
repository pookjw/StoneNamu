//
//  DecksViewModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "DecksSectionModel.h"
#import "DecksItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSCollectionViewDiffableDataSource<DecksSectionModel *, DecksItemModel *> DecksDataSource;

static NSNotificationName NSNotificationNameDecksViewModelApplyingSnapshotToDataSourceWasDone = @"NSNotificationNameDecksViewModelApplyingSnapshotToDataSourceWasDone";

static NSNotificationName const NSNotificationNameDecksViewModelShouldUpdateOptions = @"NSNotificationNameDecksViewModelShouldUpdateOptions";
static NSString * const DecksViewModelShouldUpdateOptionsSlugsAndNamesItemKey = @"DecksViewModelShouldUpdateOptionsSlugsAndNamesItemKey";
static NSString * const DecksViewModelShouldUpdateOptionsSlugsAndIdsItemKey = @"DecksViewModelShouldUpdateOptionsSlugsAndIdsItemKey";

typedef void (^DecksViewModelFetchDeckCodeCompletion)(LocalDeck * _Nullable, HSDeck * _Nullable, NSError * _Nullable);
typedef void (^DecksViewModelMakeLocalDeckCompletion)(LocalDeck *);
typedef void (^DecksViewModelParseClipboardCompletion)(NSString * _Nullable, NSString * _Nullable);
typedef void (^DecksViewModelLocalDecksFromIndexPathsCompletion)(NSSet<LocalDeck *> *localDecks);
typedef void (^DecksViewModelLocalDecksFromObjectIDsCompletion)(NSSet<LocalDeck *> *localDecks, NSError * _Nullable error);

@interface DecksViewModel : NSObject
@property (retain) DecksDataSource *dataSource;
@property (retain) NSSet<NSManagedObjectID *> * _Nullable interactingObjectIDs;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(DecksDataSource *)dataSource;
- (void)requestDataSource;
- (void)requestOptions;
- (void)fetchDeckCode:(NSString *)deckCode title:(NSString * _Nullable)title completion:(DecksViewModelFetchDeckCodeCompletion)completion;
- (void)makeLocalDeckWithClassSlug:(NSString *)classSlug deckFormat:(HSDeckFormat)deckFormat completion:(DecksViewModelMakeLocalDeckCompletion)completion;
- (void)deleteLocalDecks:(NSSet<LocalDeck *> *)localDecks;
- (void)deleteLocalDecksFromObjectIDs:(NSSet<NSManagedObjectID *> *)objectIDs;
- (void)updateDeckName:(NSString *)name forLocalDeck:(LocalDeck *)localDeck;
- (void)updateDeckName:(NSString *)name forObjectID:(NSManagedObjectID *)objectID;
- (void)parseClipboardForDeckCodeWithCompletion:(DecksViewModelParseClipboardCompletion)completion;
- (void)localDecksFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths completion:(DecksViewModelLocalDecksFromIndexPathsCompletion)completion;
- (NSSet<LocalDeck *> *)localDecksFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths;
- (NSSet<NSManagedObjectID *> *)objectIDsFromLocalDecks:(NSSet<LocalDeck *> *)localDecks;
- (void)localDecksFromObjectIDs:(NSSet<NSManagedObjectID *> *)objectIDs completion:(DecksViewModelLocalDecksFromObjectIDsCompletion)completion;
@end

NS_ASSUME_NONNULL_END
