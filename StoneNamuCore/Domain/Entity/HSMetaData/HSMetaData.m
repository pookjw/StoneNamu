//
//  HSMetaData.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSMetaData.h>

@implementation HSMetaData

- (void)dealloc {
    [_sets release];
    [_setGroups release];
    [_gameModes release];
    [_arenaIds release];
    [_types release];
    [_rarities release];
    [_classes release];
    [_minionTypes release];
    [_spellSchools release];
    [_mercenaryRoles release];
    [_keywords release];
    [_cardBackCategories release];
    [super dealloc];
}

+ (HSMetaData *)hsCardMetaDataFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSMetaData *hsCardMetaData = [HSMetaData new];
    
    NSMutableSet<HSCardSet *> *sets = [NSMutableSet<HSCardSet *> new];
    [(NSArray<NSDictionary *> *)dic[@"sets"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [sets addObject:[HSCardSet hsCardSetFromDic:obj error:error]];
    }];
    [hsCardMetaData->_sets release];
    hsCardMetaData->_sets = [sets copy];
    [sets release];
    
    NSMutableSet<HSCardSetGroups *> *setGroups = [NSMutableSet<HSCardSetGroups *> new];
    [(NSArray<NSDictionary *> *)dic[@"setGroups"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [setGroups addObject:[HSCardSetGroups hsCardSetGroupsFromDic:obj error:error]];
    }];
    [hsCardMetaData->_setGroups release];
    hsCardMetaData->_setGroups = [setGroups copy];
    [setGroups release];
    
    NSMutableSet<HSCardGameMode *> *gameModes = [NSMutableSet<HSCardGameMode *> new];
    [(NSArray<NSDictionary *> *)dic[@"gameModes"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [gameModes addObject:[HSCardGameMode hsCardGameModeFromDic:obj error:error]];
    }];
    [hsCardMetaData->_gameModes release];
    hsCardMetaData->_gameModes = [gameModes copy];
    [gameModes release];
    
    NSMutableSet<NSNumber *> *arenaIds = [NSMutableSet<NSNumber *> new];
    [(NSArray<id> *)dic[@"arenaIds"] enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSNumber.class]) {
            [arenaIds addObject:obj];
        }
    }];
    [hsCardMetaData->_arenaIds release];
    hsCardMetaData->_arenaIds = [arenaIds copy];
    [arenaIds release];
    
    NSMutableSet<HSCardType *> *types = [NSMutableSet<HSCardType *> new];
    [(NSArray<NSDictionary *> *)dic[@"types"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [types addObject:[HSCardType hsCardTypeFromDic:obj error:error]];
    }];
    [hsCardMetaData->_types release];
    hsCardMetaData->_types = [types copy];
    [types release];
    
    NSMutableSet<HSCardRarity *> *rarities = [NSMutableSet<HSCardRarity *> new];
    [(NSArray<NSDictionary *> *)dic[@"rarities"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [rarities addObject:[HSCardRarity hsCardRarityFromDic:obj error:error]];
    }];
    [hsCardMetaData->_rarities release];
    hsCardMetaData->_rarities = [rarities copy];
    [rarities release];
    
    NSMutableSet<HSCardClass *> *classes = [NSMutableSet<HSCardClass *> new];
    [(NSArray<NSDictionary *> *)dic[@"classes"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [classes addObject:[HSCardClass hsCardClassFromDic:obj error:error]];
    }];
    [hsCardMetaData->_classes release];
    hsCardMetaData->_classes = [classes copy];
    [classes release];
    
    NSMutableSet<HSCardMinionType *> *minionTypes = [NSMutableSet<HSCardMinionType *> new];
    [(NSArray<NSDictionary *> *)dic[@"minionTypes"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [minionTypes addObject:[HSCardMinionType hsCardMinionTypeFromDic:obj error:error]];
    }];
    [hsCardMetaData->_minionTypes release];
    hsCardMetaData->_minionTypes = [minionTypes copy];
    [minionTypes release];
    
    NSMutableSet<HSCardSpellSchool *> *spellSchools = [NSMutableSet<HSCardSpellSchool *> new];
    [(NSArray<NSDictionary *> *)dic[@"spellSchools"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [spellSchools addObject:[HSCardSpellSchool hsCardSpellSchoolFromDic:obj error:error]];
    }];
    [hsCardMetaData->_spellSchools release];
    hsCardMetaData->_spellSchools = [spellSchools copy];
    [spellSchools release];
    
    NSMutableSet<HSCardMercenaryRole *> *mercenaryRoles = [NSMutableSet<HSCardMercenaryRole *> new];
    [(NSArray<NSDictionary *> *)dic[@"mercenaryRoles"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mercenaryRoles addObject:[HSCardMercenaryRole hsCardMercenaryRoleFromDic:obj error:error]];
    }];
    [hsCardMetaData->_mercenaryRoles release];
    hsCardMetaData->_mercenaryRoles = [mercenaryRoles copy];
    [mercenaryRoles release];
    
    NSMutableSet<HSCardKeyword *> *keywords = [NSMutableSet<HSCardKeyword *> new];
    [(NSArray<NSDictionary *> *)dic[@"keywords"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [keywords addObject:[HSCardKeyword hsCardKeywordFromDic:obj error:error]];
    }];
    [hsCardMetaData->_keywords release];
    hsCardMetaData->_keywords = [keywords copy];
    [keywords release];
    
    NSMutableSet<HSCardBackCategory *> *cardBackCategories = [NSMutableSet<HSCardBackCategory *> new];
    [(NSArray<NSDictionary *> *)dic[@"cardBackCategories"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cardBackCategories addObject:[HSCardBackCategory hsCardBackCategoryFromDic:obj error:error]];
    }];
    [hsCardMetaData->_cardBackCategories release];
    hsCardMetaData->_cardBackCategories = [cardBackCategories copy];
    [cardBackCategories release];
    
    return [hsCardMetaData autorelease];
}

#pragma mark - HSCardMetaData

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSMetaData *_copy = (HSMetaData *)copy;
        
        [_copy->_sets release];
        _copy->_sets = [self.sets copyWithZone:zone];
        
        [_copy->_setGroups release];
        _copy->_setGroups = [self.setGroups copyWithZone:zone];
        
        [_copy->_gameModes release];
        _copy->_gameModes = [self.gameModes copyWithZone:zone];
        
        [_copy->_arenaIds release];
        _copy->_arenaIds = [self.arenaIds copyWithZone:zone];
        
        [_copy->_types release];
        _copy->_types = [self.types copyWithZone:zone];
        
        [_copy->_rarities release];
        _copy->_rarities = [self.rarities copyWithZone:zone];
        
        [_copy->_classes release];
        _copy->_classes = [self.classes copyWithZone:zone];
        
        [_copy->_minionTypes release];
        _copy->_minionTypes = [self.minionTypes copyWithZone:zone];
        
        [_copy->_spellSchools release];
        _copy->_spellSchools = [self.spellSchools copyWithZone:zone];
        
        [_copy->_mercenaryRoles release];
        _copy->_mercenaryRoles = [self.mercenaryRoles copyWithZone:zone];
        
        [_copy->_keywords release];
        _copy->_keywords = [self.keywords copyWithZone:zone];
        
        [_copy->_cardBackCategories release];
        _copy->_cardBackCategories = [self.cardBackCategories copyWithZone:zone];
    }
    
    return copy;
}

@end
