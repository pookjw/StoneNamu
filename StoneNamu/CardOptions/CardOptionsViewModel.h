//
//  CardOptionsViewModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>
#import "CardOptionsSectionModel.h"
#import "CardOptionsItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef UICollectionViewDiffableDataSource<CardOptionsSectionModel *, CardOptionsItemModel *> CardOptionsDataSource;

@interface CardOptionsViewModel : NSObject
@property (readonly, retain) CardOptionsDataSource *dataSource;
- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource;
@end

NS_ASSUME_NONNULL_END
