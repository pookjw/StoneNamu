//
//  ResourcesService.m
//  StoneNamuResources
//
//  Created by Jinwoo Kim on 11/12/21.
//

#import <StoneNamuResources/ResourcesService.h>
#import <StoneNamuResources/Identifier.h>
#import <CoreText/CoreText.h>

static NSArray<FontKey> * _Nullable kRegisteredFontKeys = @[];

@implementation ResourcesService

#if TARGET_OS_IPHONE
+ (UIImage * _Nullable)imageForKey:(ImageKey)imageKey {
    return [UIImage imageNamed:imageKey inBundle:[NSBundle bundleWithIdentifier:IDENTIFIER] withConfiguration:nil];
}
#elif TARGET_OS_OSX
+ (NSImage * _Nullable)imageForKey:(ImageKey)imageKey {
    return [[NSBundle bundleWithIdentifier:IDENTIFIER] imageForResource:imageKey];
}
#endif

#if TARGET_OS_IPHONE
+ (UIImage * _Nullable)imageForBlizzardHSAPIOptionType:(BlizzardHSAPIOptionType)optionType fill:(BOOL)fill {
    NSString *name;
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        name = @"book.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        name = @"person.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        name = @"dollarsign.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        name = @"staroflife.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        name = @"heart.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        name = @"tray.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        name = @"star.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        name = @"list.bullet.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        name = @"list.bullet.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        name = @"line.3.crossed.swirl.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        name = @"list.bullet.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        name = @"a.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        name = @"flag.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        name = @"arrow.up.arrow.down.circle";
    } else {
        return nil;
    }
    
    if (fill) {
        return [UIImage systemImageNamed:[name stringByAppendingString:@".fill"]];
    } else {
        return [UIImage systemImageNamed:name];
    }
}

+ (UIImage * _Nullable)imageForCardSet:(HSCardSet)cardSet {
    return [ResourcesService imageForKey:NSStringFromHSCardSet(cardSet)];
}

+ (UIImage * _Nullable)imageForDeckFormat:(HSDeckFormat)deckFormat {
    if ([deckFormat isEqualToString:HSDeckFormatStandard]) {
        return [ResourcesService imageForKey:ImageKeyStandard];
    } else if ([deckFormat isEqualToString:HSDeckFormatWild]) {
        return [ResourcesService imageForKey:ImageKeyWild];
    } else if ([deckFormat isEqualToString:HSDeckFormatClassic]) {
        return [ResourcesService imageForKey:ImageKeyClassicCards];
    } else {
        return nil;
    }
}

+ (UIImage * _Nullable)portraitImageForClassId:(HSCardClass)classId {
    ImageKey _Nullable imageKey = nil;
    
    switch (classId) {
        case HSCardClassDemonHunter:
            imageKey = ImageKeyDemonHunterPortrait;
            break;
        case HSCardClassDruid:
            imageKey = ImageKeyDruidPortrait;
            break;
        case HSCardClassHunter:
            imageKey = ImageKeyHunterPortrait;
            break;
        case HSCardClassMage:
            imageKey = ImageKeyMagePortrait;
            break;
        case HSCardClassPaladin:
            imageKey = ImageKeyPaladinPortrait;
            break;
        case HSCardClassPriest:
            imageKey = ImageKeyPriestPortrait;
            break;
        case HSCardClassRogue:
            imageKey = ImageKeyRoguePortrait;
            break;
        case HSCardClassShaman:
            imageKey = ImageKeyShamanPortrait;
            break;
        case HSCardClassWarlock:
            imageKey = ImageKeyWarlockPortrait;
            break;
        case HSCardClassWarrior:
            imageKey = ImageKeyWarriorPortrait;
            break;
        default:
            break;
    }
    
    if (imageKey == nil) {
        return nil;
    }
    
    return [ResourcesService imageForKey:imageKey];
}
#elif TARGET_OS_OSX
+ (NSImage * _Nullable)imageForBlizzardHSAPIOptionType:(BlizzardHSAPIOptionType)optionType fill:(BOOL)fill {
    NSString *name;
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        name = @"book.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        name = @"person.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        name = @"dollarsign.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        name = @"staroflife.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        name = @"heart.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        name = @"tray.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        name = @"star.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        name = @"list.bullet.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        name = @"list.bullet.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        name = @"line.3.crossed.swirl.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        name = @"list.bullet.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        name = @"a.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        name = @"flag.circle";
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        name = @"arrow.up.arrow.down.circle";
    } else {
        return nil;
    }
    
    if (fill) {
        return [NSImage imageWithSystemSymbolName:[name stringByAppendingString:@".fill"] accessibilityDescription:nil];
    } else {
        return [NSImage imageWithSystemSymbolName:name accessibilityDescription:nil];
    }
}

+ (NSImage * _Nullable)imageForCardSet:(HSCardSet)cardSet {
    return [ResourcesService imageForKey:NSStringFromHSCardSet(cardSet)];
}

+ (NSImage * _Nullable)imageForDeckFormat:(HSDeckFormat)deckFormat {
    if ([deckFormat isEqualToString:HSDeckFormatStandard]) {
        return [ResourcesService imageForKey:ImageKeyStandard];
    } else if ([deckFormat isEqualToString:HSDeckFormatWild]) {
        return [ResourcesService imageForKey:ImageKeyWild];
    } else if ([deckFormat isEqualToString:HSDeckFormatClassic]) {
        return [ResourcesService imageForKey:ImageKeyClassicCards];
    } else {
        return nil;
    }
}

+ (NSImage * _Nullable)portraitImageForClassId:(HSCardClass)classId {
    ImageKey _Nullable imageKey = nil;
    
    switch (classId) {
        case HSCardClassDemonHunter:
            imageKey = ImageKeyDemonHunterPortrait;
            break;
        case HSCardClassDruid:
            imageKey = ImageKeyDruidPortrait;
            break;
        case HSCardClassHunter:
            imageKey = ImageKeyHunterPortrait;
            break;
        case HSCardClassMage:
            imageKey = ImageKeyMagePortrait;
            break;
        case HSCardClassPaladin:
            imageKey = ImageKeyPaladinPortrait;
            break;
        case HSCardClassPriest:
            imageKey = ImageKeyPriestPortrait;
            break;
        case HSCardClassRogue:
            imageKey = ImageKeyRoguePortrait;
            break;
        case HSCardClassShaman:
            imageKey = ImageKeyShamanPortrait;
            break;
        case HSCardClassWarlock:
            imageKey = ImageKeyWarlockPortrait;
            break;
        case HSCardClassWarrior:
            imageKey = ImageKeyWarriorPortrait;
            break;
        default:
            break;
    }
    
    if (imageKey == nil) {
        return nil;
    }
    
    return [ResourcesService imageForKey:imageKey];
}
#endif

+ (NSString *)localizationForKey:(LocalizableKey)localizableKey {
    return NSLocalizedStringFromTableInBundle(localizableKey,
                                              @"Localizable",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSString *)localizationForBlizzardAPIRegionHost:(BlizzardAPIRegionHost)region {
    return NSLocalizedStringFromTableInBundle(NSStringForAPIFromRegionHost(region),
                                              @"BlizzardAPIRegionHost",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsWithBlizzardAPIRegionHostForAPI {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [blizzardHSAPIRegionsForAPI() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForBlizzardAPIRegionHost:BlizzardAPIRegionHostFromNSStringForAPI(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];

}

+ (NSString *)localizationForBlizzardHSAPILocale:(BlizzardHSAPILocale)locale {
    return NSLocalizedStringFromTableInBundle(locale,
                                              @"BlizzardHSAPILocale",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *, NSString *> *)localizationsWithBlizzardHSAPILocale {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [blizzardHSAPILocales() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForBlizzardHSAPILocale:obj];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForBlizzardHSAPIOptionType:(BlizzardHSAPIOptionType)optionType {
    return NSLocalizedStringFromTableInBundle(optionType,
                                              @"BlizzardHSAPIOptionType",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSString *)localizationForHSCardCollectible:(HSCardCollectible)collectible {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardCollectible(collectible),
                                              @"HSCardCollectible",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary *)localizationsForHSCardCollectible {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardCollectibles() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSCardCollectible:HSCardCollectibleFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForHSCardClass:(HSCardClass)hsCardClass {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardClass(hsCardClass),
                                              @"HSCardClass",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSCardClass {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardClasses() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSCardClass:HSCardClassFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSCardClassForFormat:(HSDeckFormat)hsDeckFormat {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardClassesForFormat(hsDeckFormat) enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSCardClass:HSCardClassFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}

+ (NSString *)localizationForHSCardRarity:(HSCardRarity)hsCardRarity {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardRarity(hsCardRarity),
                                              @"HSCardRarity",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSCardRarity {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardRarities() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSCardRarity:HSCardRarityFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForHSCardSet:(HSCardSet)hsCardSet {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardSet(hsCardSet),
                                              @"HSCardSet",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSCardSet {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardSets() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSCardSet:HSCardSetFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSCardSetForHSDeckFormat:(HSDeckFormat)hsDeckFormat {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardSetsFromHSDeckFormat(hsDeckFormat) enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSCardSet:HSCardSetFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForHSCardType:(HSCardType)hsCardType {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardType(hsCardType),
                                              @"HSCardType",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSCardType {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardTypes() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSCardType:HSCardTypeFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForHSCardMinionType:(HSCardMinionType)hsCardMinionType {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardMinionType(hsCardMinionType),
                                              @"HSCardMinionType",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSCardMinionType {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardMinionTypes() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSCardMinionType:HSCardMinionTypeFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForHSCardSpellSchool:(HSCardSpellSchool)hsCardSpellSchool {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardSpellSchool(hsCardSpellSchool),
                                              @"HSCardSpellSchool",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSCardSpellSchool {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardSpellSchools() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSCardSpellSchool:HSCardSpellSchoolFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForHSCardKeyword:(HSCardKeyword)hsCardKeyword {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardKeyword(hsCardKeyword),
                                              @"HSCardKeyword",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSCardKeyword {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardKeywords() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSCardKeyword:HSCardKeywordFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForHSCardGameMode:(HSCardGameMode)hsCardGameMode {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardGameMode(hsCardGameMode),
                                              @"HSCardGameMode",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSCardGameMode {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardGameModes() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSCardGameMode:HSCardGameModeFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForHSCardSort:(HSCardSort)hsCardSort {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardSort(hsCardSort),
                                              @"HSCardSort",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSCardSort {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardSorts() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSCardSort:HSCardSortFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForHSDeckFormat:(HSDeckFormat)hsDeckFormat {
    return NSLocalizedStringFromTableInBundle(hsDeckFormat,
                                              @"HSDeckFormat",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSDeckFormat {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsDeckFormats() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSDeckFormat:obj];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForHSYear:(HSYear)hsYear {
    return NSLocalizedStringFromTableInBundle(hsYear,
                                              @"HSYear",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSYear {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsYears() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [ResourcesService localizationForHSYear:obj];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForHSDeck:(HSDeck *)hsDeck title:(NSString *)title {
    NSMutableString *result = [@"" mutableCopy];
    NSString *classTitle = NSLocalizedStringFromTableInBundle(@"CLASS",
                                                               @"HSDeck",
                                                               [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                               @"");
    NSString *formatTitle = NSLocalizedStringFromTableInBundle(@"FORMAT",
                                                               @"HSDeck",
                                                               [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                               @"");
    NSString *footer1Title = NSLocalizedStringFromTableInBundle(@"FOOTER_1",
                                                               @"HSDeck",
                                                               [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                               @"");
    NSString *footer2Title = NSLocalizedStringFromTableInBundle(@"FOOTER_2",
                                                               @"HSDeck",
                                                               [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                               @"");
    
    NSString *className = [ResourcesService localizationForHSCardClass:hsDeck.classId];
    NSString *formatName = [ResourcesService localizationForHSDeckFormat:hsDeck.format];
    
    [result appendFormat:@"### %@\n", title];
    [result appendFormat:@"# %@: %@\n", classTitle, className];
    [result appendFormat:@"# %@: %@\n", formatTitle, formatName];
    [result appendString:@"#\n"];
    
    //
    
    NSArray<HSCard *> *sortedCards = [hsDeck.cards sortedArrayUsingComparator:^NSComparisonResult(HSCard * _Nonnull obj1, HSCard * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray<HSCard *> *addedCards = [@[] mutableCopy];
    
    [sortedCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([addedCards containsObject:obj]) {
            return;
        }
        
        NSUInteger count = [sortedCards countOfObject:obj];
        NSUInteger cost = obj.manaCost;
        NSString *name = obj.name;
        [result appendFormat:@"# %lux (%lu) %@\n", count, cost, name];
        [addedCards addObject:obj];
    }];
    
    [addedCards release];
    
    //
    
    [result appendString:@"#\n"];
    [result appendFormat:@"%@\n", hsDeck.deckCode];
    [result appendString:@"#\n"];
    [result appendFormat:@"# %@\n", footer1Title];
    [result appendFormat:@"# %@", footer2Title];
    
    //
    
    return [result autorelease];
}

#if TARGET_OS_IPHONE
+ (UIFont * _Nullable)fontForKey:(FontKey)fontKey size:(CGFloat)size {
    [self registerFontIfNeededWithName:fontKey];
    UIFont *customFont = [UIFont fontWithName:fontKey size:size];
    UIFont *result = [UIFontMetrics.defaultMetrics scaledFontForFont:customFont];
    return result;
}
#elif TARGET_OS_OSX
+ (NSFont * _Nullable)fontForKey:(FontKey)fontKey size:(CGFloat)size {
    [self registerFontIfNeededWithName:fontKey];
    NSFont *customFont = [NSFont fontWithName:fontKey size:size];
    return customFont;
}
#endif

+ (void)registerFontIfNeededWithName:(NSString *)name {
    if ([kRegisteredFontKeys containsString:name]) {
        return;
    }
    
    NSURL *url = [[NSBundle bundleWithIdentifier:IDENTIFIER] URLForResource:name withExtension:@"ttf"];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    
    CFErrorRef _Nullable error = nil;
    CTFontManagerRegisterGraphicsFont(font, &error);
    
    if (error != nil) {
        NSLog(@"%@", ((NSError *)error).localizedDescription);
        return;
    }
    
    NSArray<FontKey> *new = [kRegisteredFontKeys arrayByAddingObject:name];
    [kRegisteredFontKeys release];
    kRegisteredFontKeys = [new copy];
}

@end
