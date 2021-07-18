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

/*
 TODO : Get RegionHost or LocaleKey from Persistent Data Layer
 */

@interface HSCardUseCaseImpl ()
@property (retain) NSObject<HSCardRepository> *hsCardRepository;
@end

@implementation HSCardUseCaseImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        HSCardRepositoryImpl *hsCardRepository = [HSCardRepositoryImpl new];
        self.hsCardRepository = hsCardRepository;
        [hsCardRepository release];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCardRepository release];
    [super dealloc];
}

- (void)fetchWithOptions:(NSDictionary<NSString *, id> * _Nullable)options
       completionHandler:(HSCardUseCaseCardsCompletion)completion {
    NSDictionary *finalOptions = [self addLocalKeyIfNeeded:options];
    
    [self.hsCardRepository fetchCardsAtRegion:BlizzardAPIRegionHostKR
                                  withOptions:finalOptions
                            completionHandler:completion];
}

- (void)fetchWithIdOrSlug:(NSString *)idOrSlug
               withOptions:(NSDictionary<NSString *, id> * _Nullable)options
        completionHandler:(HSCardUseCaseCardCompletion)completion {
    NSDictionary *finalOptions = [self addLocalKeyIfNeeded:options];
    
    [self.hsCardRepository fetchCardAtRegion:BlizzardAPIRegionHostKR
                                withIdOrSlug:idOrSlug
                                 withOptions:finalOptions
                           completionHandler:completion];
}

- (NSDictionary *)addLocalKeyIfNeeded:(NSDictionary * _Nullable)options {
    if (options == nil) {
        return @{BlizzardHSAPILocaleKey: NSStringFromLocale(BlizzardHSAPILocaleKoKR)};
    } else if ([options.allKeys containsObject:BlizzardHSAPILocaleKey]) {
        return options;
    } else {
        NSMutableDictionary *mutableOptions = [options mutableCopy];
        mutableOptions[BlizzardHSAPILocaleKey] = NSStringFromLocale(BlizzardHSAPILocaleKoKR);
        NSDictionary *result = [[mutableOptions copy] autorelease];
        [mutableOptions release];
        return result;
    }
}

@end
