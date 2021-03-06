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
#import <StoneNamuCore/NSDictionary+combine.h>
#import <StoneNamuCore/HSMetaDataUseCaseImpl.h>

@interface HSDeckUseCaseImpl ()
@property (retain) id<HSDeckRepository> hsDeckRepository;
@property (retain) id<PrefsUseCase> prefsUseCase;
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
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
        
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_hsDeckRepository release];
    [_prefsUseCase release];
    [_hsMetaDataUseCase release];
    [super dealloc];
}

- (NSDictionary<NSString * ,NSString *> *)parseDeckCodeFromString:(NSString *)string {
    NSString * __block title = @"";
    NSString * __block deckCode = @"";
    
    for (NSString *tmp in [string componentsSeparatedByString:@"\n"]) {
        if ([tmp hasPrefix:@"###"]) {
            title = [tmp componentsSeparatedByString:@"### "].lastObject;
        } else if ([tmp hasPrefix:@"AA"]) {
            deckCode = tmp;
        }
    }
    
    return @{title: deckCode};
}

- (void)fetchDeckByCardList:(nonnull NSArray<NSNumber *> *)cardList
                    classId:(NSNumber *)classId
                 completion:(nonnull HSDeckUseCaseFetchDeckByCardListCompletion)completion {
    [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error) {
        [hsMetaData.classes enumerateObjectsUsingBlock:^(HSCardClass * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj.classId isEqualToNumber:classId]) {
                NSString *strList = [cardList componentsJoinedByString:@","];
                NSDictionary *options = @{BlizzardHSAPIOptionTypeIds: strList,
                                          BlizzardHSAPIOptionTypeHero: obj.heroCardId.stringValue};
                [self fetchPrefsOptions:options completion:^(NSDictionary *finalOptions, NSNumber *region) {
                    [self.hsDeckRepository fetchDeckAtRegion:region.unsignedIntegerValue
                                                 withOptions:finalOptions
                                                  completion:completion];
                }];
            }
        }];
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
        
        NSString *locale;
        
        if (prefs.locale) {
            locale = prefs.locale;
        } else {
            locale = Prefs.alternativeLocale;
        }
        
        completion([options dictionaryByAddingKey:BlizzardHSAPIOptionTypeLocale value:locale shouldOverride:YES], [NSNumber numberWithUnsignedInteger:BlizzardAPIRegionHostFromNSStringForAPI(apiRegionHost)]);
    }];
}

@end
