//
//  DeckDetailsManaCostContentViewModel.h
//  DeckDetailsManaCostContentViewModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import <UIKit/UIKit.h>
#import "DeckDetailsManaCostContentSectionModel.h"
#import "DeckDetailsManaCostContentItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef UICollectionViewDiffableDataSource<DeckDetailsManaCostContentSectionModel *, DeckDetailsManaCostContentItemModel *> DeckDetailsManaCostContentDataSource;

static NSUInteger DeckDetailsManaCostContentViewModelCountOfData = 11;

@interface DeckDetailsManaCostContentViewModel : NSObject
@property (readonly, retain) DeckDetailsManaCostContentDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(DeckDetailsManaCostContentDataSource *)dataSource;
- (void)requestDataSourceWithManaDictionary:(NSDictionary<NSNumber *, NSNumber *> *)manaDictionary;
@end

NS_ASSUME_NONNULL_END
