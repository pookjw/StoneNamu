//
//  DeckAddCardsViewModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>
#import "DeckAddCardSectionModel.h"
#import "DeckAddCardItemModel.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNameDeckAddCardsViewModelError = @"NSNotificationNameDeckAddCardsViewModelError";
static NSString * const DeckAddCardsViewModelErrorNotificationErrorKey = @"DeckAddCardsViewModelErrorNotificationErrorKey";

static NSNotificationName const NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSource = @"NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSource";
static NSNotificationName const NSNotificationNameDeckAddCardsViewModelEndedLoadingDataSource = @"NSNotificationNameDeckAddCardsViewModelEndedLoadingDataSource";

static NSNotificationName const NSNotificationNameDeckAddCardsViewModelLocalDeckHasChanged = @"NSNotificationNameDeckAddCardsViewModelLocalDeckHasChanged";
static NSString * const DeckAddCardsViewModelLocalDeckHasChangedCountOfLocalDeckCardsItemKey = @"DeckAddCardsViewModelLocalDeckHasChangedCountOfLocalDeckCardsItemKey";

typedef void (^DeckAddCardsViewModelDefaultOptionsCompletion)(NSDictionary<NSString *, NSSet<NSString *> *> *options);
typedef void (^DeckAddCardsViewModelCountOfLocalDeckCardsCompletion)(NSNumber * _Nullable countOfLocalDeckCards, BOOL isFull);

typedef UICollectionViewDiffableDataSource<DeckAddCardSectionModel *, DeckAddCardItemModel *> CardsDataSource;

@interface DeckAddCardsViewModel : NSObject
@property (retain) LocalDeck * _Nullable localDeck;
@property (copy) NSIndexPath * _Nullable contextMenuIndexPath;
@property (readonly, retain) CardsDataSource *dataSource;
@property (readonly, copy) NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable options;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardsDataSource *)dataSource;
- (void)defaultOptionsWithCompletion:(DeckAddCardsViewModelDefaultOptionsCompletion)completion;
- (void)countOfLocalDeckCardsWithCompletion:(DeckAddCardsViewModelCountOfLocalDeckCardsCompletion)completion;
- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options reset:(BOOL)reset;
- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath image:(UIImage * _Nullable)image;
- (void)addHSCards:(NSSet<HSCard *> *)hsCards;
- (void)addHSCardsFromIndexPathes:(NSSet<NSIndexPath *> *)indexPathes;
@end

NS_ASSUME_NONNULL_END
