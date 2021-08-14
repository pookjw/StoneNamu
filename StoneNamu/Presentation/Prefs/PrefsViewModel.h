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

typedef NSString * Pookjw NS_STRING_ENUM;
static Pookjw const PookjwGitHub = @"https://github.com/pookjw";

typedef NSString * Pnamu NS_STRING_ENUM;
static Pnamu const PnamuTwitter = @"https://twitter.com/Pnamu";
static Pnamu const PnamuTwitch = @"https://www.twitch.tv/Pnamu";
static Pnamu const PnamuYouTube= @"https://www.youtube.com/c/Pnamu";

typedef UICollectionViewDiffableDataSource<PrefsSectionModel *, PrefsItemModel *> PrefsDataSource;

@interface PrefsViewModel : NSObject
@property (retain) NSIndexPath * _Nullable contextMenuIndexPath;
@property (readonly, retain) PrefsDataSource *dataSource;
- (instancetype)initWithDataSource:(PrefsDataSource *)dataSource;
- (NSString * _Nullable)headerTextFromIndexPath:(NSIndexPath *)indexPath;
- (NSString * _Nullable)footerTextFromIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
