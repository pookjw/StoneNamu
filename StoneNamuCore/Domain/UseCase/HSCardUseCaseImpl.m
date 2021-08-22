//
//  HSCardUseCaseImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import "HSCardUseCaseImpl.h"
#import "HSCardRepositoryImpl.h"
#import "BlizzardHSAPIKeys.h"
#import "BlizzardHSAPILocale.h"
#import "PrefsUseCaseImpl.h"
#import "DataCacheUseCaseImpl.h"

@interface HSCardUseCaseImpl ()
@property (retain) id<HSCardRepository> hsCardRepository;
@property (retain) id<PrefsUseCase> prefsUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
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
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCardRepository release];
    [_prefsUseCase release];
    [_dataCacheUseCase release];
    [super dealloc];
}

- (void)fetchWithOptions:(NSDictionary<NSString *, id> * _Nullable)options
       completionHandler:(HSCardUseCaseCardsCompletion)completion {
    [self fetchPrefsWithOptions:options completion:^(NSDictionary *finalOptions, NSNumber *region) {
        [self.hsCardRepository fetchCardsAtRegion:region.unsignedIntegerValue
                                      withOptions:finalOptions
                                completionHandler:completion];
    }];
}

- (void)fetchWithIdOrSlug:(NSString *)idOrSlug
              withOptions:(NSDictionary<NSString *, id> * _Nullable)options
        completionHandler:(HSCardUseCaseCardCompletion)completion {
    
    [self.dataCacheUseCase dataCachesWithIdentity:idOrSlug completion:^(NSArray<NSData *> * _Nullable datas, NSError * _Nullable error) {
        
        if ((datas != nil) && (datas.count > 1)) {
            NSError * _Nullable archvingError = nil;
            HSCard *hsCard = [NSKeyedUnarchiver unarchivedObjectOfClasses:HSCard.unarchvingClasses fromData:datas.lastObject error:&archvingError];
            if (archvingError) NSLog(@"%@", archvingError.localizedDescription);
            
            completion(hsCard, error);
        } else {
            [self fetchPrefsWithOptions:options completion:^(NSDictionary *finalOptions, NSNumber *region) {
                [self.hsCardRepository fetchCardAtRegion:region.unsignedIntegerValue
                                            withIdOrSlug:idOrSlug
                                             withOptions:finalOptions
                                       completionHandler:^(HSCard * _Nullable hsCard, NSError * _Nullable error) {
                    
                    NSError * _Nullable archvingError = nil;
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:hsCard requiringSecureCoding:YES error:&archvingError];
                    if (archvingError) NSLog(@"%@", archvingError.localizedDescription);
                    
                    [self.dataCacheUseCase makeDataCache:data identity:idOrSlug];
                    [self.dataCacheUseCase saveChanges];
                    completion(hsCard, error);
                }];
            }];
        }
    }];
}

- (void)fetchPrefsWithOptions:(NSDictionary * _Nullable)options completion:(void (^)(NSDictionary *, NSNumber *))completion {
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
