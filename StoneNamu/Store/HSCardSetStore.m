//
//  HSCardSetStore.m
//  HSCardSetStore
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import "HSCardSetStore.h"
#import "HSCardSet.h"

@interface HSCardSetStore ()
@property (class, readonly, nonatomic) NSDictionary<NSString *, NSString *> *sets;
@end

@implementation HSCardSetStore

+ (NSArray<PickerItemModel *> *)pickerItemModels {
    NSMutableArray<PickerItemModel *> *pickerItemModels = [@[] mutableCopy];
    
    [HSCardSetStore.sets enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        PickerItemModel *pickerItemModel = [[PickerItemModel alloc] initWithImage:[UIImage imageNamed:key]
                                                                            title:obj
                                                                         identity:key];
        [pickerItemModels addObject:pickerItemModel];
        [pickerItemModel release];
    }];
    
    NSArray<PickerItemModel *> *results = [[pickerItemModels copy] autorelease];
    [pickerItemModels release];
    
    return results;
}

+ (NSDictionary<NSString *,NSString *> *)sets {
    return @{
        NSStringFromHSCardSet(HSCardSetLegacy): @"고전 (번역)",
        NSStringFromHSCardSet(HSCardSetNaxxramas): @"낙스라마스의 저주 (번역)",
        NSStringFromHSCardSet(HSCardSetGoblinsVsGnomes): @"고블린 대 노움 (번역)",
        NSStringFromHSCardSet(HSCardSetBlackRockMountain): @"검은바위 산 (번역)",
        NSStringFromHSCardSet(HSCardSetTheGrandTournament): @"대 마상시험 (번역)",
        NSStringFromHSCardSet(HSCardSetLeagueOfExplorers): @"탐험가 연맹 (번역)",
        NSStringFromHSCardSet(HSCardSetWhispersOfTheOldGods): @"고대 신의 속삭임 (번역)",
        NSStringFromHSCardSet(HSCardSetOneNightInKarazhan): @"한여름 밤의 카라잔 (번역)",
        NSStringFromHSCardSet(HSCardSetMeanStreetOfGadgetzan): @"비열한 거리의 가젯잔 (번역)",
        NSStringFromHSCardSet(HSCardSetJourneyToUngoro): @"운고로를 향한 여정 (번역)",
        NSStringFromHSCardSet(HSCardSetKnightsOfTheFrozenThrone): @"얼어붙은 왕좌의 기사들 (번역)",
        NSStringFromHSCardSet(HSCardSetKoboldsAndCatacombs): @"코볼트와 지하 미궁 (번역)",
        NSStringFromHSCardSet(HSCardSetTheWitchwood): @"마녀숲 (번역)",
        NSStringFromHSCardSet(HSCardSetTheBoomsdayProject): @"박사 붐의 폭심만만 프로젝트 (번역)",
        NSStringFromHSCardSet(HSCardSetRastakhansRumble): @"라스타칸의 대난투 (번역)",
        NSStringFromHSCardSet(HSCardSetRiseOfShadows): @"어둠의 반격 (번역)",
        NSStringFromHSCardSet(HSCardSetSaviorsOfUldum): @"울둠의 구원자 (번역)",
        NSStringFromHSCardSet(HSCardSetDescentOfDragons): @"용의 강림 (번역)",
        NSStringFromHSCardSet(HSCardSetGalakrondsAwakening): @"갈라크론드의 부활 (번역)",
        NSStringFromHSCardSet(HSCardSetDemonHunderInitiate): @"수습 악마사냥꾼 (번역)",
        NSStringFromHSCardSet(HSCardSetCore): @"핵심 (번역)",
        NSStringFromHSCardSet(HSCardSetAshesOfOutland): @"황폐한 아웃랜드 (번역)",
        NSStringFromHSCardSet(HSCardSetScholomanceAcademy): @"스칼로맨스 아카데미 (번역)",
        NSStringFromHSCardSet(HSCardSetMadnessAtTheDarkmoonFaire): @"광기의 다크문 축제 (번역)",
        NSStringFromHSCardSet(HSCardSetForgedInTheBarrens): @"불모의 땅 (번역)",
        NSStringFromHSCardSet(HSCardSetUnitedInStormWind): @"스톰윈드 (번역)",
        NSStringFromHSCardSet(HSCardSetClassicCards): @"오리지널 (번역)"
    };
}

@end
