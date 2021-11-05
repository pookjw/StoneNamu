//
//  HSDeckUseCaseImpl.m
//  HSDeckUseCaseImpl
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import <StoneNamuCore/HSDeckUseCaseImpl.h>
#import <StoneNamuCore/HSDeckRepositoryImpl.h>
#import <StoneNamuCore/BlizzardHSAPIKeys.h>
#import <StoneNamuCore/BlizzardHSAPILocale.h>
#import <StoneNamuCore/PrefsUseCaseImpl.h>

@interface HSDeckUseCaseImpl ()
@property (retain) id<HSDeckRepository> hsDeckRepository;
@property (retain) id<PrefsUseCase> prefsUseCase;
@end

@implementation HSDeckUseCaseImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        HSDeckRepositoryImpl *hsDeckRepository = [HSDeckRepositoryImpl new];
        self.hsDeckRepository = hsDeckRepository;
        [hsDeckRepository release];
        
        PrefsUseCaseImpl *prefsUseCase = [PrefsUseCaseImpl new];
        self.prefsUseCase = prefsUseCase;
        [prefsUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_hsDeckRepository release];
    [_prefsUseCase release];
    [super dealloc];
}

- (void)fetchDeckByCardList:(nonnull NSArray<NSNumber *> *)cardList
                    classId:(HSCardClass)classId
                 completion:(nonnull HSDeckUseCaseFetchDeckByCardListCompletion)completion {
    NSString *strList = [cardList componentsJoinedByString:@","];
    NSDictionary *options = @{BlizzardHSAPIOptionTypeIds: strList,
                              BlizzardHSAPIOptionTypeHero: [NSNumber numberWithUnsignedInteger:HSCardHeroFromHSCardClass(classId)].stringValue};
    [self fetchPrefsOptions:options completion:^(NSDictionary *finalOptions, NSNumber *region) {
        [self.hsDeckRepository fetchDeckAtRegion:region.unsignedIntegerValue
                                     withOptions:finalOptions
                                      completion:completion];
    }];
}

- (void)fetchDeckByDeckCode:(nonnull NSString *)deckCode completion:(nonnull HSDeckUseCaseFetchDeckByDeckCodeCompletion)completion {
    NSDictionary *options = @{BlizzardHSAPIOptionTypeCode: deckCode};
    [self fetchPrefsOptions:options completion:^(NSDictionary *finalOptions, NSNumber *region) {
        [self.hsDeckRepository fetchDeckAtRegion:region.unsignedIntegerValue
                                     withOptions:finalOptions
                                      completion:completion];
    }];
}

- (void)fetchPrefsOptions:(NSDictionary * _Nullable)options completion:(void (^)(NSDictionary *, NSNumber *))completion {
    [self.prefsUseCase fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
        
        NSString *apiRegionHost;
        
        if (prefs.apiRegionHost) {
            apiRegionHost = prefs.apiRegionHost;
        } else {
            apiRegionHost = Prefs.alternativeAPIRegionHost;
        }
        
        completion([prefs addLocalKeyIfNeedToOptions:options], [NSNumber numberWithUnsignedInteger:BlizzardAPIRegionHostFromNSStringForAPI(apiRegionHost)]);
    }];
}

@end
