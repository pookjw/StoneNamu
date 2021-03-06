//
//  PrefsCardsViewModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/15/21.
//

#import "PrefsCardsViewModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface PrefsCardsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<PrefsUseCase> prefsUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
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
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(didReceivePrefsChanged:)
                                                   name:NSNotificationNamePrefsUseCaseObserveData
                                                 object:prefsUseCase];
        self.prefsUseCase = prefsUseCase;
        [prefsUseCase release];
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_queue release];
    [_prefsUseCase release];
    [_dataCacheUseCase release];
    [_hsMetaDataUseCase release];
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
        [self.hsMetaDataUseCase clearCache];
//        [self.dataCacheUseCase deleteAllDataCaches];
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
        [self.hsMetaDataUseCase clearCache];
//        [self.dataCacheUseCase deleteAllDataCaches];
    }];
}

- (void)localesWithCompletion:(PrefsCardsViewModelLocalesCompletion)completion {
    [self.queue addOperationWithBlock:^{
        NSArray<BlizzardHSAPILocale> *sortedLocales = [blizzardHSAPILocales() sortedArrayUsingComparator:^NSComparisonResult(BlizzardHSAPILocale _Nonnull obj1, BlizzardHSAPILocale _Nonnull obj2) {
            NSString *lhs = [ResourcesService localizationForBlizzardHSAPILocale:obj1];
            NSString *rhs = [ResourcesService localizationForBlizzardHSAPILocale:obj2];
            return [lhs compare:rhs];
        }];
        
        completion(sortedLocales);
    }];
}

- (void)regionsWithCompletion:(PrefsCardsViewModelRegionsCompletion)completion {
    [self.queue addOperationWithBlock:^{
        NSArray<NSString *> *sortedRegions = [blizzardHSAPIRegionsForAPI() sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
            NSString *lhs = [ResourcesService localizationForBlizzardAPIRegionHost:BlizzardAPIRegionHostFromNSStringForAPI(obj1)];
            NSString *rhs = [ResourcesService localizationForBlizzardAPIRegionHost:BlizzardAPIRegionHostFromNSStringForAPI(obj2)];
            return [lhs compare:rhs];
        }];
        
        completion(sortedRegions);
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
