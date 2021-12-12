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

typedef void (^DecksViewModelFetchDeckCodeCompletion)(LocalDeck * _Nullable, HSDeck * _Nullable, NSError * _Nullable);
typedef void (^DecksViewModelMakeLocalDeckCompletion)(LocalDeck *);
typedef void (^DecksViewModelParseClipboardCompletion)(NSString * _Nullable, NSString * _Nullable);

@interface DecksViewModel : NSObject
@property (retain) DecksDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(DecksDataSource *)dataSource;
- (void)fetchDeckCode:(NSString *)deckCode title:(NSString * _Nullable)title completion:(DecksViewModelFetchDeckCodeCompletion)completion;
- (void)makeLocalDeckWithClass:(HSCardClass)hsCardClass deckFormat:(HSDeckFormat)deckFormat completion:(DecksViewModelMakeLocalDeckCompletion)completion;
- (void)deleteLocalDeckFromIndexPath:(NSIndexPath *)indexPath;
- (void)parseClipboardForDeckCodeWithCompletion:(DecksViewModelParseClipboardCompletion)completion;
- (NSIndexPath * _Nullable)indexPathForLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
