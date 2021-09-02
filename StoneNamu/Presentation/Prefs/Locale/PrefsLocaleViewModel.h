//
//  PrefsLocaleViewModel.h
//  PrefsLocaleViewModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <UIKit/UIKit.h>
#import "PrefsLocaleSectionModel.h"
#import "PrefsLocaleItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef UICollectionViewDiffableDataSource<PrefsLocaleSectionModel *, PrefsLocaleItemModel *> PrefsLocaleDataSource;

@interface PrefsLocaleViewModel : NSObject
@property (readonly, retain) PrefsLocaleDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(PrefsLocaleDataSource *)dataSource;
- (void)updateLocaleFromIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
