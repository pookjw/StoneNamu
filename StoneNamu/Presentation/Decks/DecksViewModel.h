//
//  DecksViewModel.h
//  DecksViewModel
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import <UIKit/UIKit.h>
#import "LocalDeck.h"
#import "HSDeck.h"
#import "DecksSectionModel.h"
#import "DecksItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^DecksViewModelFetchDeckCodeCompletion)(LocalDeck * _Nullable, HSDeck * _Nullable, NSError * _Nullable);
typedef void (^DecksViewModelMakeLocalDeckCompletion)(LocalDeck *);
typedef void (^DecksViewModelParseClipboardCompletion)(NSString * _Nullable, NSString * _Nullable);

typedef UICollectionViewDiffableDataSource<DecksSectionModel *, DecksItemModel *> DecksDataSource;

@interface DecksViewModel : NSObject
@property (retain) DecksDataSource *dataSource;
@property (retain) NSIndexPath * _Nullable contextMenuIndexPath;
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
