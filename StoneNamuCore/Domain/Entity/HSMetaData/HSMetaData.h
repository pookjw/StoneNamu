//
//  HSMetaData.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSCardSet.h>
#import <StoneNamuCore/HSCardSetGroups.h>
#import <StoneNamuCore/HSCardGameMode.h>
#import <StoneNamuCore/HSCardType.h>
#import <StoneNamuCore/HSCardRarity.h>
#import <StoneNamuCore/HSCardClass.h>
#import <StoneNamuCore/HSCardMinionType.h>
#import <StoneNamuCore/HSCardSpellSchool.h>
#import <StoneNamuCore/HSCardMercenaryRole.h>
#import <StoneNamuCore/HSCardKeyword.h>
#import <StoneNamuCore/HSCardBackCategory.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSMetaData : NSObject <NSCopying>
@property (readonly, copy) NSSet<HSCardSet *> *sets;
@property (readonly, copy) NSSet<HSCardSetGroups *> *setGroups;
@property (readonly, copy) NSSet<HSCardGameMode *> *gameModes;
@property (readonly, copy) NSSet<NSNumber *> *arenaIds;
@property (readonly, copy) NSSet<HSCardType *> *types;
@property (readonly, copy) NSSet<HSCardRarity *> *rarities;
@property (readonly, copy) NSSet<HSCardClass *> *classes;
@property (readonly, copy) NSSet<HSCardMinionType *> *minionTypes;
@property (readonly, copy) NSSet<HSCardSpellSchool *> *spellSchools;
@property (readonly, copy) NSSet<HSCardMercenaryRole *> *mercenaryRoles;
@property (readonly, copy) NSSet<HSCardKeyword *> *keywords;
@property (readonly, copy) NSSet<HSCardBackCategory *> *cardBackCategories;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (HSMetaData *)hsCardMetaDataFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
@end

NS_ASSUME_NONNULL_END
