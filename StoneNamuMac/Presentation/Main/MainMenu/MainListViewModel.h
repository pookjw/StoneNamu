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

typedef NSTableViewDiffableDataSource<MainListSectionModel *, MainListItemModel *> MainListDataSource;

typedef void (^MainListViewModelRowForItemModelTypeCompletion)(NSInteger);

@interface MainListViewModel : NSObject
@property (readonly, retain) MainListDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(MainListDataSource *)dataSource;
- (void)rowForItemModelType:(MainListItemModelType)type completion:(MainListViewModelRowForItemModelTypeCompletion)completion;
@end

NS_ASSUME_NONNULL_END
