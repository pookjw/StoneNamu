//
//  HSCardUseCaseImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <StoneNamuCore/HSCardUseCaseImpl.h>
#import <StoneNamuCore/HSCardRepositoryImpl.h>
#import <StoneNamuCore/BlizzardHSAPIKeys.h>
#import <StoneNamuCore/BlizzardHSAPILocale.h>
#import <StoneNamuCore/PrefsUseCaseImpl.h>
#import <StoneNamuCore/DataCacheUseCaseImpl.h>
#import <StoneNamuCore/NSDictionary+combine.h>

@interface HSCardUseCaseImpl ()
@property (retain) id<HSCardRepository> hsCardRepository;
@property (retain) id<PrefsUseCase> prefsUseCase;
@end

@implementation HSCardUseCaseImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        HSCardRepositoryImpl *hsCardRepository = [HSCardRepositoryImpl new];
        self.hsCardRepository = hsCardRepository;
        [hsCardRepository release];
        
        PrefsUseCaseImpl *prefsUseCase = [PrefsUseCaseImpl new];
        self.prefsUseCase = prefsUseCase;
        [prefsUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCardRepository release];
    [_prefsUseCase release];
    [super dealloc];
}

- (void)fetchWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options
       completionHandler:(HSCardUseCaseCardsCompletion)completion {
    [self fetchPrefsWithOptions:options completion:^(NSDictionary *prefOptions, NSNumber *region) {
        [self.hsCardRepository fetchCardsAtRegion:region.unsignedIntegerValue
                                      withOptions:prefOptions
                                completionHandler:completion];
    }];
}

- (void)fetchWithIdOrSlug:(NSString *)idOrSlug
              withOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options
        completionHandler:(HSCardUseCaseCardCompletion)completion {
    
    [self fetchPrefsWithOptions:options completion:^(NSDictionary *prefOptions, NSNumber *region) {
        [self.hsCardRepository fetchCardAtRegion:region.unsignedIntegerValue
                                    withIdOrSlug:idOrSlug
                                     withOptions:prefOptions
                               completionHandler:completion];
    }];
}

- (void)fetchPrefsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options completion:(void (^)(NSDictionary<NSString *, NSString *> *prefOptions, NSNumber *region))completion {
    [self.prefsUseCase fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
        NSString *apiRegionHost;
        
        if (prefs.apiRegionHost) {
            apiRegionHost = prefs.apiRegionHost;
        } else {
            apiRegionHost = Prefs.alternativeAPIRegionHost;
        }
        
        //
        
        NSString *locale;
        
        if (prefs.locale) {
            locale = prefs.locale;
        } else {
            locale = Prefs.alternativeLocale;
        }
        
        //
        
        NSMutableDictionary<NSString *, NSString *> *prefOptions = [NSMutableDictionary<NSString *, NSString *> new];
        
        [options enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSSet<NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
            if (obj.count > 0) {
                prefOptions[key] = [obj.allObjects componentsJoinedByString:@","];
            }
        }];
        
        prefOptions[BlizzardHSAPIOptionTypeLocale] = locale;
        
        completion([prefOptions autorelease], [NSNumber numberWithUnsignedInteger:BlizzardAPIRegionHostFromNSStringForAPI(apiRegionHost)]);
    }];
}

@end
