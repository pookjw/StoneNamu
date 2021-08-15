//
//  CardDetailsChildrenContentViewModel.h
//  CardDetailsChildrenContentViewModel
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import <UIKit/UIKit.h>
#import "HSCard.h"
#import "CardDetailsChildrenContentSectionModel.h"
#import "CardDetailsChildrenContentItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef UICollectionViewDiffableDataSource<CardDetailsChildrenContentSectionModel *, CardDetailsChildrenContentItemModel *> CardDetailsChildrenContentDataSource;

@interface CardDetailsChildrenContentViewModel : NSObject
@property (retain) NSIndexPath * _Nullable contextMenuIndexPath;
@property (readonly, retain) CardDetailsChildrenContentDataSource *dataSource;
- (instancetype)initWithDataSource:(CardDetailsChildrenContentDataSource *)dataSource;
- (void)requestChildCards:(NSArray<HSCard *> *)childCards;
- (CardDetailsChildrenContentItemModel * _Nullable)itemModelOfIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
