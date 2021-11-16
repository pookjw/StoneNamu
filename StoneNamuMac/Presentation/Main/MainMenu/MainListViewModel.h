//
//  MainListViewModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/16/21.
//

#import <Cocoa/Cocoa.h>
#import "MainListSectionModel.h"
#import "MainListItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSCollectionViewDiffableDataSource<MainListSectionModel *, MainListItemModel *> MainListDataSource;

typedef void (^MainListViewModelIndexPathForItemModelTypeCompletion)(NSIndexPath * _Nullable);

@interface MainListViewModel : NSObject
@property (readonly, retain) MainListDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(MainListDataSource *)dataSource;
- (void)request;
- (void)indexPathForItemModelType:(MainListItemModelType)type completion:(MainListViewModelIndexPathForItemModelTypeCompletion)completion;
- (MainListItemModel * _Nullable)itemModelForndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
