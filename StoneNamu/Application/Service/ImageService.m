//
//  ImageService.m
//  ImageService
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "ImageService.h"

@implementation ImageService

+ (ImageService *)sharedInstance {
    static ImageService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [ImageService new];
    });
    
    return sharedInstance;
}

- (UIImage * _Nullable)imageOfCardSet:(HSCardSet)cardSet {
    return [UIImage imageNamed:NSStringFromHSCardSet(cardSet)];
}

- (UIImage * _Nullable)portraitImageOfClassId:(HSCardClass)classId {
    NSString * _Nullable imageName = nil;
    
    switch (classId) {
        case HSCardClassDemonHunter:
            imageName = @"demon_hunter_portrait";
            break;
        case HSCardClassDruid:
            imageName = @"druid_portrait";
            break;
        case HSCardClassHunter:
            imageName = @"hunter_portrait";
            break;
        case HSCardClassMage:
            imageName = @"mage_portrait";
            break;
        case HSCardClassPaladin:
            imageName = @"paladin_portrait";
            break;
        case HSCardClassPriest:
            imageName = @"priest_portrait";
            break;
        case HSCardClassRogue:
            imageName = @"rogue_portrait";
            break;
        case HSCardClassShaman:
            imageName = @"shaman_portrait";
            break;
        case HSCardClassWarlock:
            imageName = @"warlock_portrait";
            break;
        case HSCardClassWarrior:
            imageName = @"warrior_portrait";
            break;
        default:
            break;
    }
    
    if (imageName == nil) {
        return nil;
    }
    
    return [UIImage imageNamed:imageName];
}

@end
