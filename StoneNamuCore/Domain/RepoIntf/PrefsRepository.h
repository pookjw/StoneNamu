//
//  PrefsRepository.h
//  PrefsRepository
//
//  Created by Jinwoo Kim on 8/10/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/Prefs.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PrefsRepositoryFetchWithCompletion)(Prefs * _Nullable, NSError * _Nullable);

static NSString * const PrefsRepositoryObserveDataNotificationName = @"PrefsRepositoryObserveDataNotificationName";
static NSString * const PrefsRepositoryPrefsNotificationItemKey = @"PrefsRepositoryPrefsNotificationItemKey";

@protocol PrefsRepository <NSObject>
- (void)saveChanges;
- (void)fetchWithCompletion:(PrefsRepositoryFetchWithCompletion)completion;
@end

NS_ASSUME_NONNULL_END
