//
//  PrefsRegionHostViewModel.h
//  PrefsRegionHostViewModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <UIKit/UIKit.h>
#import "PrefsRegionHostSectionModel.h"
#import "PrefsRegionHostItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef UICollectionViewDiffableDataSource<PrefsRegionHostSectionModel *, PrefsRegionHostItemModel *> PrefsRegionHostDataSource;

@interface PrefsRegionHostViewModel : NSObject
@property (readonly, retain) PrefsRegionHostDataSource *dataSource;
- (instancetype)initWithDataSource:(PrefsRegionHostDataSource *)dataSource;
- (void)updateRegionHostFromIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
