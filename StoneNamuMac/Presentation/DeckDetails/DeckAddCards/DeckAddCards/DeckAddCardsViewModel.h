//
//  DeckAddCardsViewModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/8/21.
//

#import <Cocoa/Cocoa.h>
#import "DeckAddCardSectionModel.h"
#import "DeckAddCardItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNameDeckAddCardsViewModelError = @"NSNotificationNameDeckAddCardsViewModelError";
static NSString * const DeckAddCardsViewModelErrorNotificationErrorKey = @"DeckAddCardsViewModelErrorNotificationErrorKey";

static NSNotificationName const NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSource = @"NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSource";
static NSNotificationName const NSNotificationNameDeckAddCardsViewModelEndedLoadingDataSource = @"NSNotificationNameDeckAddCardsViewModelEndedLoadingDataSource";

typedef NSCollectionViewDiffableDataSource<DeckAddCardSectionModel *, DeckAddCardItemModel *> DeckAddCardsDataSource;

@interface DeckAddCardsViewModel : NSObject
@property (readonly, retain) DeckAddCardsDataSource *dataSource;
@property (readonly, copy) NSDictionary<NSString *, id> * _Nullable options;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(DeckAddCardsDataSource *)dataSource;
- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options reset:(BOOL)reset;
@end

NS_ASSUME_NONNULL_END
