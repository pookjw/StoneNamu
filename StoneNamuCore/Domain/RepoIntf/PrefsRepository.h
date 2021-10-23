//
//  PrefsRepository.h
//  PrefsRepository
//
//  Created by Jinwoo Kim on 8/10/21.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_OSX
#import <StoneNamuMacCore/Prefs.h>
#else
#import <StoneNamuCore/Prefs.h>
#endif

NS_ASSUME_NONNULL_BEGIN

typedef void (^PrefsRepositoryFetchWithCompletion)(Prefs * _Nullable, NSError * _Nullable);

static NSString * const PrefsRepositoryObserveDataNotificationName = @"PrefsRepositoryObserveDataNotificationName";
static NSString * const PrefsRepositoryPrefsNotificationItemKey = @"PrefsRepositoryPrefsNotificationItemKey";

@protocol PrefsRepository <NSObject>
- (void)saveChanges;
- (void)fetchWithCompletion:(PrefsRepositoryFetchWithCompletion)completion;
@end

NS_ASSUME_NONNULL_END
