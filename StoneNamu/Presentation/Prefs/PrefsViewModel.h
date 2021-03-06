//
//  PrefsViewModel.h
//  PrefsViewModel
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import <UIKit/UIKit.h>
#import "PrefsSectionModel.h"
#import "PrefsItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef UICollectionViewDiffableDataSource<PrefsSectionModel *, PrefsItemModel *> PrefsDataSource;

@interface PrefsViewModel : NSObject
@property (copy) NSIndexPath * _Nullable contextMenuIndexPath;
@property (readonly, retain) PrefsDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(PrefsDataSource *)dataSource;
- (NSString * _Nullable)headerTextFromIndexPath:(NSIndexPath *)indexPath;
- (NSString * _Nullable)footerTextFromIndexPath:(NSIndexPath *)indexPath;
- (void)deleteAllCahces;
- (void)deleteAllLocalDecks;
@end

NS_ASSUME_NONNULL_END
