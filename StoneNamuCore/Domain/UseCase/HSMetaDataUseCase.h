//
//  HSMetaDataUseCase.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSMetaData.h>
#import <StoneNamuCore/BlizzardHSAPIKeys.h>
#import <StoneNamuCore/HSDeckFormat.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HSMetaDataUseCaseFetchMetaDataCompletion)(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error);

@protocol HSMetaDataUseCase <NSObject>
- (void)fetchWithCompletionHandler:(HSMetaDataUseCaseFetchMetaDataCompletion)completionHandler;
- (void)clearCache;

- (HSCardSet * _Nullable)hsCardSetFromSetId:(NSNumber *)setId usingHSMetaData:(HSMetaData *)hsMetaData;
- (HSCardSet * _Nullable)hsCardSetFromSetSlug:(HSCardSetSlugType)setSlug usingHSMetaData:(HSMetaData *)hsMetaData;
- (HSCardSetGroups * _Nullable)hsCardSetGroupsFromSetGroupsSlug:(HSCardSetGroupsSlugType)setGroupsSlug usingHSMetaData:(HSMetaData *)hsMetaData;
- (HSCardType * _Nullable)hsCardTypeFromTypeId:(NSNumber *)typeId usingHSMetaData:(HSMetaData *)hsMetaData;
- (HSCardRarity * _Nullable)hsCardRarityFromRarityId:(NSNumber *)raridyId usingHSMetaData:(HSMetaData *)hsMetaData;
- (HSCardRarity * _Nullable)hsCardRarityFromRaritySlug:(HSCardRaritySlugType)slug usingHSMetaData:(HSMetaData *)hsMetaData;
- (HSCardClass * _Nullable)hsCardClassFromClassId:(NSNumber *)classId usingHSMetaData:(HSMetaData *)hsMetaData;
- (HSCardClass * _Nullable)hsCardClassFromClassSlug:(HSCardClassSlugType)slug usingHSMetaData:(HSMetaData *)hsMetaData;

- (HSCardSetGroups * _Nullable)latestHsCardSetGroupsUsingHSMetaData:(HSMetaData *)hsMetaData;

- (NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSString *> *> *)hsDeckFormatsAndSlugsAndNamesUsingHSMetaData:(HSMetaData *)hsMetaData;
- (NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSNumber *> *> *)hsDeckFormatsAndSlugsAndIdsUsingHSMetaData:(HSMetaData *)hsMetaData;
- (NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *)optionTypesAndSlugsAndNamesFromHSDeckFormat:(HSDeckFormat _Nullable)hsDeckFormat withClassId:(NSNumber * _Nullable)classId usingHSMetaData:(HSMetaData *)hsMetaData;
- (NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *)optionTypesAndSlugsAndIdsFromHSDeckFormat:(HSDeckFormat _Nullable)hsDeckFormat withClassId:(NSNumber * _Nullable)classId usingHSMetaData:(HSMetaData *)hsMetaData;
@end

NS_ASSUME_NONNULL_END
