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

+ (UIImage * _Nullable)imageForDeckFormat:(HSDeckFormat)deckFormat {
    if ([deckFormat isEqualToString:HSDeckFormatStandard]) {
        return [self imageForKey:ImageKeyStandard];
    } else if ([deckFormat isEqualToString:HSDeckFormatWild]) {
        return [self imageForKey:ImageKeyWild];
    } else if ([deckFormat isEqualToString:HSDeckFormatClassic]) {
        return [self imageForKey:ImageKeyClassicCards];
    } else {
        return nil;
    }
}

+ (UIImage * _Nullable)portraitImageForHSCardClassSlugType:(HSCardClassSlugType)hsCardClassSlugType {
    ImageKey _Nullable imageKey = nil;
    
    if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeDemonHunder]) {
        imageKey = ImageKeyDemonHunterPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeDruid]) {
        imageKey = ImageKeyDruidPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeHunter]) {
        imageKey = ImageKeyHunterPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeMage]) {
        imageKey = ImageKeyMagePortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypePaladin]) {
        imageKey = ImageKeyPaladinPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypePriest]) {
        imageKey = ImageKeyPriestPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeRogue]) {
        imageKey = ImageKeyRoguePortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeShaman]) {
        imageKey = ImageKeyShamanPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeWarlock]) {
        imageKey = ImageKeyWarlockPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeWarrior]) {
        imageKey = ImageKeyWarriorPortrait;
    }
    
    if (imageKey == nil) {
        return nil;
    }
    
    return [self imageForKey:imageKey];
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
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTier]) {
        name = @"dollarsign.circle";
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

+ (NSImage * _Nullable)imageForDeckFormat:(HSDeckFormat)deckFormat {
    if ([deckFormat isEqualToString:HSDeckFormatStandard]) {
        return [self imageForKey:ImageKeyStandard];
    } else if ([deckFormat isEqualToString:HSDeckFormatWild]) {
        return [self imageForKey:ImageKeyWild];
    } else if ([deckFormat isEqualToString:HSDeckFormatClassic]) {
        return [self imageForKey:ImageKeyClassicCards];
    } else {
        return nil;
    }
}

+ (NSImage * _Nullable)portraitImageForHSCardClassSlugType:(HSCardClassSlugType)hsCardClassSlugType {
    ImageKey _Nullable imageKey = nil;
    
    if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeDemonHunder]) {
        imageKey = ImageKeyDemonHunterPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeDruid]) {
        imageKey = ImageKeyDruidPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeHunter]) {
        imageKey = ImageKeyHunterPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeMage]) {
        imageKey = ImageKeyMagePortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypePaladin]) {
        imageKey = ImageKeyPaladinPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypePriest]) {
        imageKey = ImageKeyPriestPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeRogue]) {
        imageKey = ImageKeyRoguePortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeShaman]) {
        imageKey = ImageKeyShamanPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeWarlock]) {
        imageKey = ImageKeyWarlockPortrait;
    } else if ([hsCardClassSlugType isEqualToString:HSCardClassSlugTypeWarrior]) {
        imageKey = ImageKeyWarriorPortrait;
    }
    
    if (imageKey == nil) {
        return nil;
    }
    
    return [self imageForKey:imageKey];
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
    NSMutableDictionary<NSString *, NSString *> *dic = [NSMutableDictionary<NSString *, NSString *> new];
    
    [blizzardHSAPIRegionsForAPI() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [self localizationForBlizzardAPIRegionHost:BlizzardAPIRegionHostFromNSStringForAPI(obj)];
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
    NSMutableDictionary<NSString *, NSString *> *dic = [NSMutableDictionary<NSString *, NSString *> new];
    
    [blizzardHSAPILocales() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [self localizationForBlizzardHSAPILocale:obj];
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
    NSMutableDictionary<NSString *, NSString *> *dic = [NSMutableDictionary<NSString *, NSString *> new];
    
    [hsCardCollectibles() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [self localizationForHSCardCollectible:HSCardCollectibleFromNSString(obj)];
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
    NSMutableDictionary<NSString *, NSString *> *dic = [NSMutableDictionary<NSString *, NSString *> new];
    
    [hsCardSorts() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [self localizationForHSCardSort:HSCardSortFromNSString(obj)];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSCardSortWithHSCardGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType {
    if ([HSCardGameModeSlugTypeConstructed isEqualToString:hsCardGameModeSlugType]) {
        NSMutableDictionary<NSString *, NSString *> *dic = [NSMutableDictionary<NSString *, NSString *> new];
        
        NSArray<NSString *> *hsCardSorts = @[
            NSStringFromHSCardSort(HSCardSortManaCostAsc),
            NSStringFromHSCardSort(HSCardSortManaCostDesc),
            NSStringFromHSCardSort(HSCardSortAttackAsc),
            NSStringFromHSCardSort(HSCardSortAttackDesc),
            NSStringFromHSCardSort(HSCardSortHealthAsc),
            NSStringFromHSCardSort(HSCardSortHealthDesc),
            NSStringFromHSCardSort(HSCardSortClassAsc),
            NSStringFromHSCardSort(HSCardSortClassDesc),
            NSStringFromHSCardSort(HSCardSortGroupByClassAsc),
            NSStringFromHSCardSort(HSCardSortGroupByClassDesc),
            NSStringFromHSCardSort(HSCardSortNameAsc),
            NSStringFromHSCardSort(HSCardSortNameDesc),
        ];
        
        [hsCardSorts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dic[obj] = [self localizationForHSCardSort:HSCardSortFromNSString(obj)];
        }];
        
        return [dic autorelease];
    } else if ([HSCardGameModeSlugTypeBattlegrounds isEqualToString:hsCardGameModeSlugType]) {
        NSMutableDictionary<NSString *, NSString *> *dic = [NSMutableDictionary<NSString *, NSString *> new];
        
        NSArray<NSString *> *hsCardSorts = @[
            NSStringFromHSCardSort(HSCardSortTierAsc),
            NSStringFromHSCardSort(HSCardSortTierDesc),
            NSStringFromHSCardSort(HSCardSortAttackAsc),
            NSStringFromHSCardSort(HSCardSortAttackDesc),
            NSStringFromHSCardSort(HSCardSortHealthAsc),
            NSStringFromHSCardSort(HSCardSortHealthDesc),
            NSStringFromHSCardSort(HSCardSortNameAsc),
            NSStringFromHSCardSort(HSCardSortNameDesc),
        ];
        
        [hsCardSorts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dic[obj] = [self localizationForHSCardSort:HSCardSortFromNSString(obj)];
        }];
        
        return [dic autorelease];
    } else {
        return @{};
    }
}

+ (NSString *)localizationForHSDeckFormat:(HSDeckFormat)hsDeckFormat {
    return NSLocalizedStringFromTableInBundle(hsDeckFormat,
                                              @"HSDeckFormat",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

+ (NSDictionary<NSString *,NSString *> *)localizationsForHSDeckFormat {
    NSMutableDictionary<NSString *, NSString *> *dic = [NSMutableDictionary<NSString *, NSString *> new];
    
    [hsDeckFormats() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = [self localizationForHSDeckFormat:obj];
    }];
    
    NSDictionary<NSString *, NSString *> *result = [dic copy];
    [dic release];
    
    return [result autorelease];
}

+ (NSString *)localizationForHSDeck:(HSDeck *)hsDeck title:(NSString *)title className:(nonnull NSString *)className {
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
    
    NSString *formatName = [self localizationForHSDeckFormat:hsDeck.format];
    
    [result appendFormat:@"### %@\n", title];
    [result appendFormat:@"# %@: %@\n", classTitle, className];
    [result appendFormat:@"# %@: %@\n", formatTitle, formatName];
    [result appendString:@"#\n"];
    
    //
    
    NSArray<HSCard *> *sortedCards = [hsDeck.cards sortedArrayUsingComparator:^NSComparisonResult(HSCard * _Nonnull obj1, HSCard * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray<HSCard *> *addedCards = [NSMutableArray<HSCard *> new];
    
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
    [data release];
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    CGDataProviderRelease(provider);
    
    CFErrorRef _Nullable error = nil;
    CTFontManagerRegisterGraphicsFont(font, &error);
    CGFontRelease(font);
    
    if (error != nil) {
        NSLog(@"%@", ((NSError *)error).localizedDescription);
        return;
    }
    
    NSArray<FontKey> *new = [kRegisteredFontKeys arrayByAddingObject:name];
    [kRegisteredFontKeys release];
    kRegisteredFontKeys = [new copy];
}

@end
