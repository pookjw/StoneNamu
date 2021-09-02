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
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardDetailsChildrenContentDataSource *)dataSource;
- (void)requestChildCards:(NSArray<HSCard *> *)childCards;
- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath image:(UIImage * _Nullable)image;
@end

NS_ASSUME_NONNULL_END
