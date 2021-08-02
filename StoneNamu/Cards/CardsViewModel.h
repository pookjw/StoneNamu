//
//  CardsViewModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>
#import "CardSectionModel.h"
#import "CardItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const CardsViewModelErrorNotificationName = @"CardsViewModelErrorNotificationName";

static NSString * const CardsViewModelNotificationErrorKey = @"error";

typedef UICollectionViewDiffableDataSource<CardSectionModel *, CardItemModel *> CardsDataSource;

@interface CardsViewModel : NSObject
@property (readonly, retain) CardsDataSource *dataSource;
- (instancetype)initWithDataSource:(CardsDataSource *)dataSource options:(NSDictionary<NSString *, id> *)options;
@end

NS_ASSUME_NONNULL_END
