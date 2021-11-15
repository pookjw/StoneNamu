//
//  PrefsCardsViewModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/15/21.
//

#import "PrefsCardsViewModel.h"

@interface PrefsCardsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<PrefsUseCase> prefsUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@end

@implementation PrefsCardsViewModel

- (instancetype)init {
    self = [super init];
    
    if (self){
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        PrefsUseCaseImpl *prefsUseCase = [PrefsUseCaseImpl new];
        self.prefsUseCase = prefsUseCase;
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(didReceivePrefsChanged:)
                                                   name:NSNotificationNamePrefsUseCaseObserveData
                                                 object:prefsUseCase];
        [prefsUseCase release];
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_queue release];
    [_prefsUseCase release];
    [_dataCacheUseCase release];
    [super dealloc];
}

- (void)requestPrefs {
    [self.prefsUseCase fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        [self postPrefs:prefs];
    }];
}

- (void)updateLocale:(BlizzardHSAPILocale _Nullable)locale {
    [self.prefsUseCase fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        prefs.locale = locale;
        [self.prefsUseCase saveChanges];
        [self.dataCacheUseCase deleteAllDataCaches];
    }];
}

- (void)updateRegionHost:(NSString * _Nullable)regionHost {
    [self.prefsUseCase fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        prefs.apiRegionHost = regionHost;
        [self.prefsUseCase saveChanges];
        [self.dataCacheUseCase deleteAllDataCaches];
    }];
}

- (void)didReceivePrefsChanged:(NSNotification *)notification {
    Prefs * _Nullable prefs = (Prefs *)notification.userInfo[PrefsUseCasePrefsNotificationItemKey];
    
    if (prefs) {
        [self postPrefs:prefs];
    }
}

- (void)postPrefs:(Prefs *)prefs {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNamePrefsCardsViewModelDidChangeData
                                                      object:self
                                                    userInfo:@{PrefsCardsViewModelDidChangeDataNotificationPrefsItemKey: prefs}];
}

@end
