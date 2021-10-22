//
//  MainViewModel.h
//  MainViewModel
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import <UIKit/UIKit.h>
#import "MainListSectionModel.h"
#import "MainListItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef UICollectionViewDiffableDataSource<MainListSectionModel *, MainListItemModel *> MainDataSource;

typedef void (^MainListViewModelIndexPathForItemTypeCompletion)(NSIndexPath * _Nullable);

@interface MainListViewModel : NSObject
@property (readonly, retain) MainDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(MainDataSource *)dataSource;
- (NSString * _Nullable)headerTextFromIndexPath:(NSIndexPath *)indexPath;
- (NSString * _Nullable)footerTextFromIndexPath:(NSIndexPath *)indexPath;
- (void)indexPathOfItemType:(MainItemModelType)itemType completion:(MainListViewModelIndexPathForItemTypeCompletion)completion;
@end

NS_ASSUME_NONNULL_END
