//
//  ImageService.m
//  ImageService
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "ImageService.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation ImageService

+ (ImageService *)sharedInstance {
    static ImageService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [ImageService new];
    });
    
    return sharedInstance;
}

- (UIImage * _Nullable)imageOfDeckFormat:(HSDeckFormat)deckFormat {
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

- (UIImage * _Nullable)imageOfCardSet:(HSCardSet)cardSet {
    return [ResourcesService imageForKey:NSStringFromHSCardSet(cardSet)];
}

- (UIImage * _Nullable)portraitImageOfClassId:(HSCardClass)classId {
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

- (UIImage *)portraitOfPnamu {
    return [ResourcesService imageForKey:ImageKeyPnamuEasteregg1];
}

@end
