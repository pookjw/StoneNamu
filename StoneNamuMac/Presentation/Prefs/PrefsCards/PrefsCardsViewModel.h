//
//  PrefsCardsViewModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/15/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const PrefsCardsViewModelDidChangeDataNotificationName = @"PrefsCardsViewModelDidChangeDataNotificationName";
static NSString * const PrefsCardsViewModelDidChangeDataNotificationPrefsItemKey = @"PrefsCardsViewModelDidChangeDataNotificationPrefsItemKey";

@interface PrefsCardsViewModel : NSObject
- (void)requestPrefs;
- (void)updateLocale:(BlizzardHSAPILocale _Nullable)locale;
- (void)updateRegionHost:(NSString * _Nullable)regionHost;
@end

NS_ASSUME_NONNULL_END
