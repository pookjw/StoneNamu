//
//  CardDetailsChildrenContentCollectionViewItemModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "CardDetailsChildrenContentCollectionViewItemSectionModel.h"
#import "CardDetailsChildrenContentCollectionViewItemItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSCollectionViewDiffableDataSource<CardDetailsChildrenContentCollectionViewItemSectionModel *, CardDetailsChildrenContentCollectionViewItemItemModel *> CardDetailsChildrenContentCollectionViewItemDataSource;

@interface CardDetailsChildrenContentCollectionViewItemModel : NSObject
@property (readonly, retain) CardDetailsChildrenContentCollectionViewItemDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardDetailsChildrenContentCollectionViewItemDataSource *)dataSource;
- (void)requestChildCards:(NSArray<HSCard *> *)childCards;
@end

NS_ASSUME_NONNULL_END
