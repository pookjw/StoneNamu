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

typedef void (^DeckAddCardsViewModelDefaultOptionsCompletion)(NSDictionary<NSString *, NSString *> *options);

typedef UICollectionViewDiffableDataSource<DeckAddCardSectionModel *, DeckAddCardItemModel *> CardsDataSource;

@interface DeckAddCardsViewModel : NSObject
@property (retain) LocalDeck * _Nullable localDeck;
@property (retain) NSIndexPath * _Nullable contextMenuIndexPath;
@property (readonly, retain) CardsDataSource *dataSource;
@property (readonly, copy) NSDictionary<NSString *, NSString *> * _Nullable options;
@property (readonly, nonatomic) BOOL isLocalDeckCardFull;
@property (readonly, nonatomic) NSUInteger countOfLocalDeckCards;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardsDataSource *)dataSource;
- (void)defaultOptionsWithCompletion:(DeckAddCardsViewModelDefaultOptionsCompletion)completion;
- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options reset:(BOOL)reset;
- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath image:(UIImage * _Nullable)image;
- (void)addHSCards:(NSSet<HSCard *> *)hsCards;
- (void)addHSCardsFromIndexPathes:(NSSet<NSIndexPath *> *)indexPathes;
@end

NS_ASSUME_NONNULL_END
