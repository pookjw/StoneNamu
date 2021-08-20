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

@interface DeckDetailsViewModel : NSObject
@property (retain) DecksDetailsDataSource *dataSource;
- (instancetype)initWithDataSource:(DecksDetailsDataSource *)dataSource;
- (void)requestDataSourcdWithLocalDeck:(LocalDeck *)localDeck;
- (void)addHSCard:(HSCard *)hsCard;
- (void)removeHSCard:(HSCard *)hsCard;
- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
