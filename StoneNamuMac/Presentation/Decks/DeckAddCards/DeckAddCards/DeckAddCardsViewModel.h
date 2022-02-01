//
//  DeckAddCardsViewModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/8/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "DeckAddCardSectionModel.h"
#import "DeckAddCardItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSCollectionViewDiffableDataSource<DeckAddCardSectionModel *, DeckAddCardItemModel *> DeckAddCardsDataSource;
typedef void (^DeckAddCardsViewModelLoadFromURIRepresentationCompletion)(BOOL result);
typedef void (^DeckAddCardsViewModelHSCardsFromIndexPathsCompletion)(NSSet<HSCard *> *);

static NSNotificationName const NSNotificationNameDeckAddCardsViewModelError = @"NSNotificationNameDeckAddCardsViewModelError";
static NSString * const DeckAddCardsViewModelErrorNotificationErrorKey = @"DeckAddCardsViewModelErrorNotificationErrorKey";

static NSNotificationName const NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSource = @"NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSource";
static NSNotificationName const NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSourceOptionsKey = @"NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSourceOptionsKey";
static NSNotificationName const NSNotificationNameDeckAddCardsViewModelEndedLoadingDataSource = @"NSNotificationNameDeckAddCardsViewModelEndedLoadingDataSource";

static NSNotificationName const NSNotificationNameDeckAddCardsViewModelLocalDeckHasChanged = @"NSNotificationNameDeckAddCardsViewModelLocalDeckHasChanged";

@interface DeckAddCardsViewModel : NSObject
@property (retain) LocalDeck * _Nullable localDeck;
@property (readonly, retain) DeckAddCardsDataSource *dataSource;
@property (readonly, copy) NSDictionary<NSString *, NSString *> * _Nullable options;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(DeckAddCardsDataSource *)dataSource;
- (void)loadLocalDeckFromURIRepresentation:(NSURL *)URIRepresentation completion:(DeckAddCardsViewModelLoadFromURIRepresentationCompletion)completion;
- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options reset:(BOOL)reset;
- (void)addHSCards:(NSSet<HSCard *> *)hsCards;
- (void)addHSCardsFromIndexPathes:(NSSet<NSIndexPath *> *)indexPathes;
- (void)hsCardsFromIndexPathsWithCompletion:(NSSet<NSIndexPath *> *)indexPaths completion:(DeckAddCardsViewModelHSCardsFromIndexPathsCompletion)completion;
- (NSSet<HSCard *> *)hsCardsFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths;
@end

NS_ASSUME_NONNULL_END
