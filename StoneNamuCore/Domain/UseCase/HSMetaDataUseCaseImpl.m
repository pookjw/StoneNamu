//
//  HSMetaDataUseCaseImpl.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSMetaDataUseCaseImpl.h>
#import <StoneNamuCore/HSMetaDataRepositoryImpl.h>
#import <StoneNamuCore/PrefsUseCaseImpl.h>
#import <StoneNamuCore/BlizzardHSAPIKeys.h>
#import <StoneNamuCore/CheckThread.h>
#import <StoneNamuCore/compareNullableValues.h>
#import <StoneNamuCore/CheckThread.h>

@interface HSMetaDataUseCaseImpl ()
@property (retain) id<HSMetaDataRepository> hsMetaDataRepository;
@property (retain) id<PrefsUseCase> prefsUseCase;
@end

@implementation HSMetaDataUseCaseImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {
        HSMetaDataRepositoryImpl *hsMetaDataRepository = [HSMetaDataRepositoryImpl new];
        self.hsMetaDataRepository = hsMetaDataRepository;
        [hsMetaDataRepository release];
        
        PrefsUseCaseImpl *prefsUseCase = [PrefsUseCaseImpl new];
        self.prefsUseCase = prefsUseCase;
        [prefsUseCase release];
        
        [self bind];
    }
    
    return self;
}

- (void)dealloc {
    [_hsMetaDataRepository release];
    [_prefsUseCase release];
    [super dealloc];
}

- (void)fetchWithCompletionHandler:(HSMetaDataUseCaseFetchMetaDataCompletion)completionHandler {
    checkThread();
    
    [self.prefsUseCase fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil, error);
            return;
        }
        
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
        
        [self.hsMetaDataRepository fetchMetaDataAtRegion:BlizzardAPIRegionHostFromNSStringForAPI(apiRegionHost)
                                             withOptions:@{BlizzardHSAPIOptionTypeLocale: locale}
                                       completionHandler:^(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error) {
            if (error) {
                completionHandler(nil, error);
                return;
            }
            
            completionHandler(hsMetaData, error);
        }];
    }];
}

- (void)clearCache {
    [self.hsMetaDataRepository clearCache];
}

- (HSCardSet *)hsCardSetFromSetId:(NSNumber *)setId usingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardSet * _Nullable __block hsCardSet = nil;
    
    [hsMetaData.sets enumerateObjectsUsingBlock:^(HSCardSet * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([setId isEqualToNumber:obj.setId]) {
            hsCardSet = [obj copy];
            *stop = YES;
        }
    }];
    
    return [hsCardSet autorelease];
}

- (HSCardSet *)hsCardSetFromSetSlug:(HSCardSetSlugType)setSlug usingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardSet * _Nullable __block hsCardSet = nil;
    
    [hsMetaData.sets enumerateObjectsUsingBlock:^(HSCardSet * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([setSlug isEqualToString:obj.slug]) {
            hsCardSet = [obj copy];
            *stop = YES;
        }
    }];
    
    return [hsCardSet autorelease];
}

- (HSCardSetGroups * _Nullable)hsCardSetGroupsFromSetGroupsSlug:(HSCardSetGroupsSlugType)setGroupsSlug usingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardSetGroups * _Nullable __block hsCardSetGroups = nil;
    
    [hsMetaData.setGroups enumerateObjectsUsingBlock:^(HSCardSetGroups * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([setGroupsSlug isEqualToString:obj.slug]) {
            hsCardSetGroups = [obj copy];
            *stop = YES;
        }
    }];
    
    return [hsCardSetGroups autorelease];
}

- (HSCardType *)hsCardTypeFromTypeId:(NSNumber *)typeId usingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardType * _Nullable __block hsCardType = nil;
    
    [hsMetaData.types enumerateObjectsUsingBlock:^(HSCardType * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([typeId isEqualToNumber:obj.typeId]) {
            hsCardType = [obj copy];
            *stop = YES;
        }
    }];
    
    return [hsCardType autorelease];
}

- (HSCardType * _Nullable)hsCardTypeFromTypeSlug:(HSCardTypeSlugType)typeSlug usingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardType * _Nullable __block hsCardType = nil;
    
    [hsMetaData.types enumerateObjectsUsingBlock:^(HSCardType * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([typeSlug isEqualToString:obj.slug]) {
            hsCardType = [obj copy];
            *stop = YES;
        }
    }];
    
    return [hsCardType autorelease];
}

- (HSCardRarity *)hsCardRarityFromRarityId:(NSNumber *)raridyId usingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardRarity * _Nullable __block hsCardRarity = nil;
    
    [hsMetaData.rarities enumerateObjectsUsingBlock:^(HSCardRarity * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([raridyId isEqualToNumber:obj.rarityId]) {
            hsCardRarity = [obj copy];
            *stop = YES;
        }
    }];
    
    return [hsCardRarity autorelease];
}

- (HSCardRarity *)hsCardRarityFromRaritySlug:(HSCardRaritySlugType)slug usingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardRarity * _Nullable __block hsCardRarity = nil;
    
    [hsMetaData.rarities enumerateObjectsUsingBlock:^(HSCardRarity * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([slug isEqualToString:obj.slug]) {
            hsCardRarity = [obj copy];
            *stop = YES;
        }
    }];
    
    return [hsCardRarity autorelease];
}

- (HSCardClass *)hsCardClassFromClassId:(NSNumber *)classId usingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardClass * _Nullable __block hsCardClass = nil;
    
    [hsMetaData.classes enumerateObjectsUsingBlock:^(HSCardClass * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([classId isEqualToNumber:obj.classId]) {
            hsCardClass = [obj copy];
            *stop = YES;
        }
    }];
    
    return [hsCardClass autorelease];
}

- (HSCardClass *)hsCardClassFromClassSlug:(HSCardClassSlugType)slug usingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardClass * _Nullable __block hsCardClass = nil;
    
    [hsMetaData.classes enumerateObjectsUsingBlock:^(HSCardClass * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([slug isEqualToString:obj.slug]) {
            hsCardClass = [obj copy];
            *stop = YES;
        }
    }];
    
    return [hsCardClass autorelease];
}

- (HSCardGameMode * _Nullable)hsCardGameModeFromGameModeSlug:(HSCardGameModeSlugType)slug usingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardGameMode * _Nullable __block hsCardGameMode = nil;
    
    [hsMetaData.gameModes enumerateObjectsUsingBlock:^(HSCardGameMode * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([slug isEqualToString:obj.slug]) {
            hsCardGameMode = [obj copy];
            *stop = YES;
        }
    }];
    
    return [hsCardGameMode autorelease];
}

- (HSCardSetGroups * _Nullable)latestHSCardSetGroupsUsingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardSetGroups * _Nullable __block hsCardSetGroups = nil;
    
    [hsMetaData.setGroups enumerateObjectsUsingBlock:^(HSCardSetGroups * _Nonnull obj, BOOL * _Nonnull stop) {
        if (hsCardSetGroups == nil) {
            hsCardSetGroups = obj;
        } else if (comparisonResultNullableValues(hsCardSetGroups.year, obj.year, @selector(compare:)) == NSOrderedAscending) {
            hsCardSetGroups = obj;
        }
    }];
    
    return hsCardSetGroups;
}

- (NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSString *> *> *)hsDeckFormatsAndClassesSlugsAndNamesUsingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    NSMutableDictionary<NSString *, NSString *> *classes = [NSMutableDictionary<NSString *, NSString *> new];
    
    [hsMetaData.classes enumerateObjectsUsingBlock:^(HSCardClass * _Nonnull obj, BOOL * _Nonnull stop) {
        classes[obj.slug] = obj.name;
    }];
    [classes removeObjectForKey:HSCardClassSlugTypeNeutral];
    
    NSMutableDictionary<NSString *, NSString *> *classicClasses = [classes mutableCopy];
    [classicClasses removeObjectForKey:HSCardClassSlugTypeDemonHunder];
    
    NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSString *> *> *result = @{
        HSDeckFormatStandard: classes,
        HSDeckFormatWild: classes,
        HSDeckFormatClassic: classicClasses
    };
    
    [classes release];
    [classicClasses release];
    
    return result;
}

- (NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSNumber *> *> *)hsDeckFormatsAndClassesSlugsAndIdsUsingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    NSMutableDictionary<NSString *, NSNumber *> *classes = [NSMutableDictionary<NSString *, NSNumber *> new];
    
    [hsMetaData.classes enumerateObjectsUsingBlock:^(HSCardClass * _Nonnull obj, BOOL * _Nonnull stop) {
        classes[obj.slug] = obj.classId;
    }];
    
    NSMutableDictionary<NSString *, NSNumber *> *classicClasses = [classes mutableCopy];
    [classicClasses removeObjectForKey:HSCardClassSlugTypeDemonHunder];
    
    NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSNumber *> *> *result = @{
        HSDeckFormatStandard: classes,
        HSDeckFormatWild: classes,
        HSDeckFormatClassic: classicClasses
    };
    
    [classes release];
    [classicClasses release];
    
    return result;
}

- (NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *)constructedOptionTypesAndSlugsAndNamesFromHSDeckFormat:(HSDeckFormat)hsDeckFormat withClassId:(NSNumber *)classId usingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardGameMode *hsCardGameMode = [self hsCardGameModeFromGameModeSlug:HSCardGameModeSlugTypeConstructed usingHSMetaData:hsMetaData];
    NSMutableDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *dataModel = [NSMutableDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> new];
    
    //
    
    NSMutableDictionary<NSString *, NSString *> *sets = [NSMutableDictionary<NSString *, NSString *> new];
    
    if (hsDeckFormat == nil) {
        [hsMetaData.sets enumerateObjectsUsingBlock:^(HSCardSet * _Nonnull obj, BOOL * _Nonnull stop) {
            sets[obj.slug] = obj.name;
        }];
    } else if ([hsDeckFormat isEqualToString:HSDeckFormatStandard]) {
        HSCardSetGroups * _Nullable hsCardSetGroups = [self hsCardSetGroupsFromSetGroupsSlug:HSCardSetGroupsSlugTypeStandard usingHSMetaData:hsMetaData];
        
        if (hsCardSetGroups) {
            [hsCardSetGroups.cardSets enumerateObjectsUsingBlock:^(NSString * _Nonnull obj1, BOOL * _Nonnull stop1) {
                [hsMetaData.sets enumerateObjectsUsingBlock:^(HSCardSet * _Nonnull obj2, BOOL * _Nonnull stop2) {
                    if ([obj1 isEqualToString:obj2.slug]) {
                        sets[obj2.slug] = obj2.name;
                        *stop2 = YES;
                    }
                }];
            }];
        }
    } else if ([hsDeckFormat isEqualToString:HSDeckFormatWild]) {
        HSCardSetGroups * _Nullable hsCardSetGroups = [self hsCardSetGroupsFromSetGroupsSlug:HSCardSetGroupsSlugTypeWild usingHSMetaData:hsMetaData];
        
        if (hsCardSetGroups) {
            [hsCardSetGroups.cardSets enumerateObjectsUsingBlock:^(NSString * _Nonnull obj1, BOOL * _Nonnull stop1) {
                [hsMetaData.sets enumerateObjectsUsingBlock:^(HSCardSet * _Nonnull obj2, BOOL * _Nonnull stop2) {
                    if ([obj1 isEqualToString:obj2.slug]) {
                        sets[obj2.slug] = obj2.name;
                        *stop2 = YES;
                    }
                }];
            }];
        }
    } else if ([hsDeckFormat isEqualToString:HSDeckFormatClassic]) {
        [hsMetaData.sets enumerateObjectsUsingBlock:^(HSCardSet * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj.slug isEqualToString:HSCardSetSlugTypeClassicCards]) {
                sets[obj.slug] = obj.name;
                *stop = YES;
            }
        }];
    }
    
    dataModel[BlizzardHSAPIOptionTypeSet] = sets;
    [sets release];
    
    //
    
    NSMutableDictionary<NSString *, NSString *> *gameModes = [NSMutableDictionary<NSString *, NSString *> new];
    [hsMetaData.gameModes enumerateObjectsUsingBlock:^(HSCardGameMode * _Nonnull obj, BOOL * _Nonnull stop) {
        gameModes[obj.slug] = obj.name;
    }];
    dataModel[BlizzardHSAPIOptionTypeGameMode] = gameModes;
    [gameModes release];
    
    //
    
    NSMutableDictionary<NSString *, NSString *> *types = [NSMutableDictionary<NSString *, NSString *> new];
    [hsMetaData.types enumerateObjectsUsingBlock:^(HSCardType * _Nonnull obj, BOOL * _Nonnull stop) {
        types[obj.slug] = obj.name;
    }];
    dataModel[BlizzardHSAPIOptionTypeType] = types;
    [types release];
    
    //
    
    NSMutableDictionary<NSString *, NSString *> *rarites = [NSMutableDictionary<NSString *, NSString *> new];
    [hsMetaData.rarities enumerateObjectsUsingBlock:^(HSCardRarity * _Nonnull obj, BOOL * _Nonnull stop) {
        rarites[obj.slug] = obj.name;
    }];
    dataModel[BlizzardHSAPIOptionTypeRarity] = rarites;
    [rarites release];
    
    //
    
    NSMutableDictionary<NSString *, NSString *> *classes = [NSMutableDictionary<NSString *, NSString *> new];
    if (classId != nil) {
        [hsMetaData.classes enumerateObjectsUsingBlock:^(HSCardClass * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj.slug isEqualToString:HSCardClassSlugTypeNeutral]) {
                classes[obj.slug] = obj.name;
                return;
            } else if ([obj.classId isEqualToNumber:classId]) {
                classes[obj.slug] = obj.name;
                return;
            }
            
            if (classes.count == 2) {
                *stop = YES;
            }
        }];
    } else if (hsDeckFormat != nil) {
        [classes release];
        classes = [[self hsDeckFormatsAndClassesSlugsAndNamesUsingHSMetaData:hsMetaData][hsDeckFormat] mutableCopy];
    } else {
        [hsMetaData.classes enumerateObjectsUsingBlock:^(HSCardClass * _Nonnull obj, BOOL * _Nonnull stop) {
            classes[obj.slug] = obj.name;
        }];
    }
    dataModel[BlizzardHSAPIOptionTypeClass] = classes;
    [classes release];
    
    //
    
    NSMutableDictionary<NSString *, NSString *> *minionTypes = [NSMutableDictionary<NSString *, NSString *> new];
    [hsMetaData.minionTypes enumerateObjectsUsingBlock:^(HSCardMinionType * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.gameModes containsObject:hsCardGameMode.gameModeId]) {
            minionTypes[obj.slug] = obj.name;
        }
    }];
    dataModel[BlizzardHSAPIOptionTypeMinionType] = minionTypes;
    [minionTypes release];
    
    //
    
    NSMutableDictionary<NSString *, NSString *> *spellSchools = [NSMutableDictionary<NSString *, NSString *> new];
    [hsMetaData.spellSchools enumerateObjectsUsingBlock:^(HSCardSpellSchool * _Nonnull obj, BOOL * _Nonnull stop) {
        spellSchools[obj.slug] = obj.name;
    }];
    dataModel[BlizzardHSAPIOptionTypeSpellSchool] = spellSchools;
    [spellSchools release];
    
    //
    
    NSMutableDictionary<NSString *, NSString *> *keywords = [NSMutableDictionary<NSString *, NSString *> new];
    [hsMetaData.keywords enumerateObjectsUsingBlock:^(HSCardKeyword * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.gameModes containsObject:hsCardGameMode.gameModeId]) {
            keywords[obj.slug] = obj.name;
        }
    }];
    dataModel[BlizzardHSAPIOptionTypeKeyword] = keywords;
    [keywords release];
    
    return [dataModel autorelease];
}

- (NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *)constructedOptionTypesAndSlugsAndIdsFromHSDeckFormat:(HSDeckFormat)hsDeckFormat withClassId:(NSNumber *)classId usingHSMetaData:(HSMetaData *)hsMetaData {
    checkThread();
    
    HSCardGameMode *hsCardGameMode = [self hsCardGameModeFromGameModeSlug:HSCardGameModeSlugTypeConstructed usingHSMetaData:hsMetaData];
    NSMutableDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *dataModel = [NSMutableDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> new];
    
    //
    
    NSMutableDictionary<NSString *, NSNumber *> *sets = [NSMutableDictionary<NSString *, NSNumber *> new];
    
    if (hsDeckFormat == nil) {
        [hsMetaData.sets enumerateObjectsUsingBlock:^(HSCardSet * _Nonnull obj, BOOL * _Nonnull stop) {
            sets[obj.slug] = obj.setId;
        }];
    } else if ([hsDeckFormat isEqualToString:HSDeckFormatStandard]) {
        HSCardSetGroups * _Nullable hsCardSetGroups = [self hsCardSetGroupsFromSetGroupsSlug:HSCardSetGroupsSlugTypeStandard usingHSMetaData:hsMetaData];
        
        if (hsCardSetGroups) {
            [hsCardSetGroups.cardSets enumerateObjectsUsingBlock:^(NSString * _Nonnull obj1, BOOL * _Nonnull stop1) {
                [hsMetaData.sets enumerateObjectsUsingBlock:^(HSCardSet * _Nonnull obj2, BOOL * _Nonnull stop2) {
                    if ([obj1 isEqualToString:obj2.slug]) {
                        sets[obj2.slug] = obj2.setId;
                        *stop2 = YES;
                    }
                }];
            }];
        }
    } else if ([hsDeckFormat isEqualToString:HSDeckFormatWild]) {
        HSCardSetGroups * _Nullable hsCardSetGroups = [self hsCardSetGroupsFromSetGroupsSlug:HSCardSetGroupsSlugTypeWild usingHSMetaData:hsMetaData];
        
        if (hsCardSetGroups) {
            [hsCardSetGroups.cardSets enumerateObjectsUsingBlock:^(NSString * _Nonnull obj1, BOOL * _Nonnull stop1) {
                [hsMetaData.sets enumerateObjectsUsingBlock:^(HSCardSet * _Nonnull obj2, BOOL * _Nonnull stop2) {
                    if ([obj1 isEqualToString:obj2.slug]) {
                        sets[obj2.slug] = obj2.setId;
                        *stop2 = YES;
                    }
                }];
            }];
        }
    } else if ([hsDeckFormat isEqualToString:HSDeckFormatClassic]) {
        [hsMetaData.sets enumerateObjectsUsingBlock:^(HSCardSet * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj.slug isEqualToString:HSCardSetSlugTypeClassicCards]) {
                sets[obj.slug] = obj.setId;
                *stop = YES;
            }
        }];
    }
    
    dataModel[BlizzardHSAPIOptionTypeSet] = sets;
    [sets release];
    
    //
    
    NSMutableDictionary<NSString *, NSNumber *> *gameModes = [NSMutableDictionary<NSString *, NSNumber *> new];
    [hsMetaData.gameModes enumerateObjectsUsingBlock:^(HSCardGameMode * _Nonnull obj, BOOL * _Nonnull stop) {
        gameModes[obj.slug] = obj.gameModeId;
    }];
    dataModel[BlizzardHSAPIOptionTypeGameMode] = gameModes;
    [gameModes release];
    
    //
    
    NSMutableDictionary<NSString *, NSNumber *> *types = [NSMutableDictionary<NSString *, NSNumber *> new];
    [hsMetaData.types enumerateObjectsUsingBlock:^(HSCardType * _Nonnull obj, BOOL * _Nonnull stop) {
        types[obj.slug] = obj.typeId;
    }];
    dataModel[BlizzardHSAPIOptionTypeType] = types;
    [types release];
    
    //
    
    NSMutableDictionary<NSString *, NSNumber *> *rarites = [NSMutableDictionary<NSString *, NSNumber *> new];
    [hsMetaData.rarities enumerateObjectsUsingBlock:^(HSCardRarity * _Nonnull obj, BOOL * _Nonnull stop) {
        rarites[obj.slug] = obj.rarityId;
    }];
    dataModel[BlizzardHSAPIOptionTypeRarity] = rarites;
    [rarites release];
    
    //
    
    NSMutableDictionary<NSString *, NSNumber *> *classes = [NSMutableDictionary<NSString *, NSNumber *> new];
    if (classId != nil) {
        [hsMetaData.classes enumerateObjectsUsingBlock:^(HSCardClass * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj.slug isEqualToString:HSCardClassSlugTypeNeutral]) {
                classes[obj.slug] = obj.classId;
                return;
            } else if ([obj.classId isEqualToNumber:classId]) {
                classes[obj.slug] = obj.classId;
                return;
            }
            
            if (classes.count == 2) {
                *stop = YES;
            }
        }];
    } else if (hsDeckFormat != nil) {
        [classes release];
        classes = [[self hsDeckFormatsAndClassesSlugsAndIdsUsingHSMetaData:hsMetaData][hsDeckFormat] mutableCopy];
    } else {
        [hsMetaData.classes enumerateObjectsUsingBlock:^(HSCardClass * _Nonnull obj, BOOL * _Nonnull stop) {
            classes[obj.slug] = obj.classId;
        }];
    }
    dataModel[BlizzardHSAPIOptionTypeClass] = classes;
    [classes release];
    
    //
    
    NSMutableDictionary<NSString *, NSNumber *> *minionTypes = [NSMutableDictionary<NSString *, NSNumber *> new];
    [hsMetaData.minionTypes enumerateObjectsUsingBlock:^(HSCardMinionType * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.gameModes containsObject:hsCardGameMode.gameModeId]) {
            minionTypes[obj.slug] = obj.minionTypeId;
        }
    }];
    dataModel[BlizzardHSAPIOptionTypeMinionType] = minionTypes;
    [minionTypes release];
    
    //
    
    NSMutableDictionary<NSString *, NSNumber *> *spellSchools = [NSMutableDictionary<NSString *, NSNumber *> new];
    [hsMetaData.spellSchools enumerateObjectsUsingBlock:^(HSCardSpellSchool * _Nonnull obj, BOOL * _Nonnull stop) {
        spellSchools[obj.slug] = obj.spellSchoolId;
    }];
    dataModel[BlizzardHSAPIOptionTypeSpellSchool] = spellSchools;
    [spellSchools release];
    
    //
    
    NSMutableDictionary<NSString *, NSNumber *> *keywords = [NSMutableDictionary<NSString *, NSNumber *> new];
    [hsMetaData.keywords enumerateObjectsUsingBlock:^(HSCardKeyword * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.gameModes containsObject:hsCardGameMode.gameModeId]) {
            keywords[obj.slug] = obj.keywordId;
        }
    }];
    dataModel[BlizzardHSAPIOptionTypeKeyword] = keywords;
    [keywords release];
    
    return [dataModel autorelease];
}

- (NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *)battlegroundsOptionTypesAndSlugsAndNamesUsingHSMetaData:(HSMetaData *)hsMetaData {
    HSCardGameMode *hsCardGameMode = [self hsCardGameModeFromGameModeSlug:HSCardGameModeSlugTypeBattlegrounds usingHSMetaData:hsMetaData];
    NSMutableDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *dataModel = [NSMutableDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> new];
    
    //
    
    NSMutableDictionary<NSString *, NSString *> *minionTypes = [NSMutableDictionary<NSString *, NSString *> new];
    [hsMetaData.minionTypes enumerateObjectsUsingBlock:^(HSCardMinionType * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.gameModes containsObject:hsCardGameMode.gameModeId]) {
            minionTypes[obj.slug] = obj.name;
        }
    }];
    dataModel[BlizzardHSAPIOptionTypeMinionType] = minionTypes;
    [minionTypes release];
    
    //
    
    NSMutableDictionary<NSString *, NSString *> *keywords = [NSMutableDictionary<NSString *, NSString *> new];
    [hsMetaData.keywords enumerateObjectsUsingBlock:^(HSCardKeyword * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.gameModes containsObject:hsCardGameMode.gameModeId]) {
            keywords[obj.slug] = obj.name;
        }
    }];
    dataModel[BlizzardHSAPIOptionTypeKeyword] = keywords;
    [keywords release];
    
    //
    
    return [dataModel autorelease];
}

- (NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *)battlegroundsOptionTypesAndSlugsAndIdsUsingHSMetaData:(HSMetaData *)hsMetaData {
    HSCardGameMode *hsCardGameMode = [self hsCardGameModeFromGameModeSlug:HSCardGameModeSlugTypeBattlegrounds usingHSMetaData:hsMetaData];
    NSMutableDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *dataModel = [NSMutableDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> new];
    
    //
    
    NSMutableDictionary<NSString *, NSNumber *> *minionTypes = [NSMutableDictionary<NSString *, NSNumber *> new];
    [hsMetaData.minionTypes enumerateObjectsUsingBlock:^(HSCardMinionType * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.gameModes containsObject:hsCardGameMode.gameModeId]) {
            minionTypes[obj.slug] = obj.minionTypeId;
        }
    }];
    dataModel[BlizzardHSAPIOptionTypeMinionType] = minionTypes;
    [minionTypes release];
    
    //
    
    NSMutableDictionary<NSString *, NSNumber *> *keywords = [NSMutableDictionary<NSString *, NSNumber *> new];
    [hsMetaData.keywords enumerateObjectsUsingBlock:^(HSCardKeyword * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.gameModes containsObject:hsCardGameMode.gameModeId]) {
            keywords[obj.slug] = obj.keywordId;
        }
    }];
    dataModel[BlizzardHSAPIOptionTypeKeyword] = keywords;
    [keywords release];
    
    //
    
    return [dataModel autorelease];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(clearCacheReceived:)
                                               name:NSNotificationNameHSMetaDataRepositoryClearCache
                                             object:self.hsMetaDataRepository];
}

- (void)clearCacheReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameHSMetaDataUseCaseClearCache
                                                      object:self
                                                    userInfo:nil];
}

@end
