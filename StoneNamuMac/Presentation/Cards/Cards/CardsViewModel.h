//
//  CardsViewModel.h
//  CardsViewModel
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import <Cocoa/Cocoa.h>
#import "CardSectionModel.h"
#import "CardItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSCollectionViewDiffableDataSource<CardSectionModel *, CardItemModel *> CardsDataSource;
typedef void (^CardsViewModelHSCardsFromIndexPathsCompletion)(NSSet<HSCard *> *);

static NSNotificationName const NSNotificationNameCardsViewModelError = @"NSNotificationNameCardsViewModelError";
static NSString * const CardsViewModelErrorNotificationErrorKey = @"CardsViewModelErrorNotificationErrorKey";

static NSNotificationName const NSNotificationNameCardsViewModelStartedLoadingDataSource = @"NSNotificationNameCardsViewModelStartedLoadingDataSource";
static NSNotificationName const NSNotificationNameCardsViewModelStartedLoadingDataSourceOptionsKey = @"NSNotificationNameCardsViewModelStartedLoadingDataSourceOptionsKey";
static NSNotificationName const NSNotificationNameCardsViewModelEndedLoadingDataSource = @"NSNotificationNameCardsViewModelEndedLoadingDataSource";

@interface CardsViewModel : NSObject
@property (readonly, retain) CardsDataSource *dataSource;
@property (readonly, copy) NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable options;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardsDataSource *)dataSource;
- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options reset:(BOOL)reset;
- (void)hsCardsFromIndexPathsWithCompletion:(NSSet<NSIndexPath *> *)indexPaths completion:(CardsViewModelHSCardsFromIndexPathsCompletion)completion;
- (NSSet<HSCard *> *)hsCardsFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths;
@end

NS_ASSUME_NONNULL_END
