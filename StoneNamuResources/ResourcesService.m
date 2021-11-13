//
//  ResourcesService.m
//  StoneNamuResources
//
//  Created by Jinwoo Kim on 11/12/21.
//

#import <StoneNamuResources/ResourcesService.h>
#import <StoneNamuResources/Identifier.h>

@implementation ResourcesService

#if TARGET_OS_IPHONE
+ (UIImage * _Nullable)imageForKey:(ImageKey)imageKey {
    return [UIImage imageNamed:imageKey inBundle:[NSBundle bundleWithIdentifier:Identifier] withConfiguration:nil];
}
#elif TARGET_OS_OSX
+ (NSImage * _Nullable)imageForKey:(ImageKey)imageKey {
    return [[NSBundle bundleWithIdentifier:Identifier] imageForResource:imageKey];
}
#endif

#if TARGET_OS_IPHONE
+ (UIImage * _Nullable)imageOfDeckFormat:(HSDeckFormat)deckFormat {
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

+ (UIImage * _Nullable)imageOfCardSet:(HSCardSet)cardSet {
    return [ResourcesService imageForKey:NSStringFromHSCardSet(cardSet)];
}

+ (UIImage * _Nullable)portraitImageOfClassId:(HSCardClass)classId {
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
#elif #if TARGET_OS_IPHONE
- (NSImage * _Nullable)imageOfDeckFormat:(HSDeckFormat)deckFormat {
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

- (NSImage * _Nullable)imageOfCardSet:(HSCardSet)cardSet {
    return [ResourcesService imageForKey:NSStringFromHSCardSet(cardSet)];
}

- (NSImage * _Nullable)portraitImageOfClassId:(HSCardClass)classId {
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

+ (NSString *)localizaedStringForKey:(LocalizableKey)localizableKey {
    return NSLocalizedStringFromTableInBundle(localizableKey,
                                              @"Localizable",
                                              [NSBundle bundleWithIdentifier:Identifier],
                                              @"");
}

@end
