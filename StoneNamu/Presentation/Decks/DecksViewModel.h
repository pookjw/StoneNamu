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

typedef UICollectionViewDiffableDataSource<DecksSectionModel *, DecksItemModel *> DecksDataSource;

@interface DecksViewModel : NSObject
@property (retain) DecksDataSource *dataSource;
- (instancetype)initWithDataSource:(DecksDataSource *)dataSource;
- (void)fetchDeckCode:(NSString *)deckCode completion:(DecksViewModelFetchDeckCodeCompletion)completion;
- (void)makeLocalDeckWithClass:(HSCardClass)hsCardClass completion:(DecksViewModelMakeLocalDeckCompletion)completion;
- (NSIndexPath * _Nullable)indexPathForLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
