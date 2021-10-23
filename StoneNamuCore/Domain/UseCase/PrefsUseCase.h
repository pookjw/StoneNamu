//
//  PrefsUseCase.h
//  PrefsUseCase
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/Prefs.h>
#else
#import <StoneNamuCore/Prefs.h>
#endif

NS_ASSUME_NONNULL_BEGIN

typedef void (^PrefsUseCaseFetchWithCompletion)(Prefs * _Nullable, NSError * _Nullable);

static NSString * const PrefsUseCaseObserveDataNotificationName = @"PrefsUseCaseObserveDataNotificationName";
static NSString * const PrefsUseCasePrefsNotificationItemKey = @"PrefsUseCasePrefsNotificationItemKey";

@protocol PrefsUseCase <NSObject>
- (void)saveChanges;
- (void)fetchWithCompletion:(PrefsUseCaseFetchWithCompletion)completion;
@end

NS_ASSUME_NONNULL_END
