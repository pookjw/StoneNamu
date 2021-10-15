//
//  MainViewModel.h
//  MainViewModel
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import <UIKit/UIKit.h>
#import "MainSectionModel.h"
#import "MainItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef UICollectionViewDiffableDataSource<MainSectionModel *, MainItemModel *> MainDataSource;

@interface MainViewModel : NSObject
@property (readonly, retain) MainDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(MainDataSource *)dataSource;
- (NSString * _Nullable)headerTextFromIndexPath:(NSIndexPath *)indexPath;
- (NSString * _Nullable)footerTextFromIndexPath:(NSIndexPath *)indexPath;
- (NSDictionary<NSString *, NSString *> * _Nullable)cardOptionsFromType:(MainItemModelType)type;
@end

NS_ASSUME_NONNULL_END
