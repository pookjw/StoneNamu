//
//  PrefsCardsViewModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/15/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNamePrefsCardsViewModelDidChangeData = @"NSNotificationNamePrefsCardsViewModelDidChangeData";
static NSString * const PrefsCardsViewModelDidChangeDataNotificationPrefsItemKey = @"PrefsCardsViewModelDidChangeDataNotificationPrefsItemKey";

typedef void (^PrefsCardsViewModelLocalesCompletion)(NSArray<BlizzardHSAPILocale> *locales);
typedef void (^PrefsCardsViewModelRegionsCompletion)(NSArray<NSString *> *regions);

@interface PrefsCardsViewModel : NSObject
- (void)requestPrefs;
- (void)updateLocale:(BlizzardHSAPILocale _Nullable)locale;
- (void)updateRegionHost:(NSString * _Nullable)regionHost;
- (void)localesWithCompletion:(PrefsCardsViewModelLocalesCompletion)completion;
- (void)regionsWithCompletion:(PrefsCardsViewModelRegionsCompletion)completion;
@end

NS_ASSUME_NONNULL_END
