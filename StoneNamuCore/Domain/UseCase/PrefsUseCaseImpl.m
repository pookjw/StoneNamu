//
//  PrefsUseCaseImpl.m
//  PrefsUseCaseImpl
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import "PrefsUseCaseImpl.h"
#import "PrefsRepositoryImpl.h"

@interface PrefsUseCaseImpl ()
@property (retain) id<PrefsRepository> prefsRepository;
@end

@implementation PrefsUseCaseImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        PrefsRepositoryImpl *prefsRepository = [PrefsRepositoryImpl new];
        self.prefsRepository = prefsRepository;
        [prefsRepository release];
        
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_prefsRepository release];
    [super dealloc];
}

- (void)fetchWithCompletion:(nonnull PrefsUseCaseFetchWithCompletion)completion {
    [self.prefsRepository fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
        completion(prefs, error);
    }];
}

- (void)saveChanges {
    [self.prefsRepository saveChanges];
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(changesReceived:)
                                               name:PrefsRepositoryObserveDataNotificationName
                                             object:self.prefsRepository];
}

- (void)changesReceived:(NSNotification *)notification {
    Prefs * _Nullable prefs = notification.userInfo[PrefsRepositoryPrefsNotificationItemKey];
    
    if (prefs) {
        [NSNotificationCenter.defaultCenter postNotificationName:PrefsUseCaseObserveDataNotificationName
                                                          object:self
                                                        userInfo:@{PrefsUseCasePrefsNotificationItemKey: prefs}];
    }
}

@end
