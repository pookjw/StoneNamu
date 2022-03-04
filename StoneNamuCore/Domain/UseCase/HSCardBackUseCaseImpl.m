//
//  HSCardBackUseCaseImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 3/5/22.
//

#import <StoneNamuCore/HSCardBackUseCaseImpl.h>
#import <StoneNamuCore/HSCardBackRepositoryImpl.h>
#import <StoneNamuCore/BlizzardHSAPIKeys.h>
#import <StoneNamuCore/BlizzardHSAPILocale.h>
#import <StoneNamuCore/PrefsUseCaseImpl.h>
#import <StoneNamuCore/NSDictionary+combine.h>
#import <StoneNamuCore/HSCardSort.h>

@interface HSCardBackUseCaseImpl ()
@property (retain) id<HSCardBackRepository> hsCardBackRepository;
@property (retain) id<PrefsUseCase> prefsUseCase;
@end

@implementation HSCardBackUseCaseImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        HSCardBackRepositoryImpl *hsCardBackRepository = [HSCardBackRepositoryImpl new];
        self.hsCardBackRepository = hsCardBackRepository;
        [hsCardBackRepository release];
        
        PrefsUseCaseImpl *prefsUseCase = [PrefsUseCaseImpl new];
        self.prefsUseCase = prefsUseCase;
        [prefsUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCardBackRepository release];
    [_prefsUseCase release];
    [super dealloc];
}

- (void)fetchWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options completionHandler:(HSCardBackUseCaseCardsCompletion)completion {
    [self fetchPrefsWithOptions:options completion:^(NSDictionary<NSString *,NSString *> *prefOptions, NSNumber *region) {
        [self.hsCardBackRepository fetchCardsAtRegion:region.unsignedIntegerValue withOptions:prefOptions completionHandler:completion];
    }];
}

- (void)fetchWithIdOrSlug:(NSString *)idOrSlug withOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options completionHandler:(HSCardBackUseCaseCardCompletion)completion {
    [self fetchPrefsWithOptions:options completion:^(NSDictionary<NSString *,NSString *> *prefOptions, NSNumber *region) {
        [self.hsCardBackRepository fetchCardAtRegion:region.unsignedIntegerValue withIdOrSlug:idOrSlug withOptions:prefOptions completionHandler:completion];
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
                if ([BlizzardHSAPIOptionTypeSort isEqualToString:key]) {
                    NSArray<NSString *> *sorted = [obj.allObjects sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
                        NSNumber *lhsNumber = [NSNumber numberWithUnsignedInteger:HSCardSortFromNSString(obj1)];
                        NSNumber *rhsNumber = [NSNumber numberWithUnsignedInteger:HSCardSortFromNSString(obj2)];
                        return [lhsNumber compare:rhsNumber];
                    }];
                    
                    prefOptions[key] = [sorted componentsJoinedByString:@","];
                } else {
                    prefOptions[key] = [obj.allObjects componentsJoinedByString:@","];
                }
            }
        }];
        
        prefOptions[BlizzardHSAPIOptionTypeLocale] = locale;
        
        completion([prefOptions autorelease], [NSNumber numberWithUnsignedInteger:BlizzardAPIRegionHostFromNSStringForAPI(apiRegionHost)]);
    }];
}


@end
