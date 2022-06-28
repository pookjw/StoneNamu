//
//  PrefsItemModel.m
//  PrefsItemModel
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import "PrefsItemModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation PrefsItemModel

- (instancetype)initWithType:(PrefsItemModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (void)dealloc {
    [_accessoryText release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    PrefsItemModel *toCompare = (PrefsItemModel *)object;
    
    if (![toCompare isKindOfClass:[PrefsItemModel class]]) {
        return NO;
    }
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

- (UIImage * _Nullable)primaryImage {
    switch (self.type) {
        case PrefsItemModelTypeLocaleSelection:
            return [UIImage systemImageNamed:@"textformat"];
        case PrefsItemModelTypeRegionSelection:
            return [UIImage systemImageNamed:@"globe"];
        case PrefsItemModelTypeDeleteAllCaches:
            return [UIImage systemImageNamed:@"trash"];
        case PrefsItemModelTypeDeleteAllLocalDecks:
            return [UIImage systemImageNamed:@"trash"];
        case PrefsItemModelTypeJoinTestFlight:
            return [UIImage systemImageNamed:@"testtube.2"];
        case PrefsItemModelTypePookjwContributor:
            return [ResourcesService imageForKey:ImageKeyPookjw];
        case PrefsItemModelTypePnamuContributor:
            return [ResourcesService imageForKey:ImageKeyPnamu];
    }
}

- (NSString * _Nullable)primaryText {
    switch (self.type) {
        case PrefsItemModelTypeLocaleSelection:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeLocale];
        case PrefsItemModelTypeRegionSelection:
            return [ResourcesService localizationForKey:LocalizableKeyRegion];
        case PrefsItemModelTypeDeleteAllCaches:
            return [ResourcesService localizationForKey:LocalizableKeyDeleteAllCaches];
        case PrefsItemModelTypeDeleteAllLocalDecks:
            return @"Remove All LocalDecks";
        case PrefsItemModelTypeJoinTestFlight:
            return [ResourcesService localizationForKey:LocalizableKeyJoinTestflight];
        case PrefsItemModelTypePookjwContributor:
            return [ResourcesService localizationForKey:LocalizableKeyPookjw];
        case PrefsItemModelTypePnamuContributor:
            return [ResourcesService localizationForKey:LocalizableKeyPnamu];
        default:
            return nil;
    }
}

- (NSString * _Nullable)secondaryText {
    switch (self.type) {
        case PrefsItemModelTypePookjwContributor:
            return [ResourcesService localizationForKey:LocalizableKeyPookjwDescription];
        case PrefsItemModelTypePnamuContributor:
            return [ResourcesService localizationForKey:LocalizableKeyPnamuDescription];
        default:
            return nil;
    }
}

- (UIListContentTextAlignment)primaryTextAlignment {
    return UIListContentTextAlignmentNatural;
}

- (BOOL)hasDisclosure {
    switch (self.type) {
        case PrefsItemModelTypeDeleteAllCaches:
            return NO;
        case PrefsItemModelTypeDeleteAllLocalDecks:
            return NO;
        case PrefsItemModelTypeJoinTestFlight:
            return NO;
        default:
            return YES;
    }
    return YES;
}

- (NSDictionary<NSString *,NSURL *> * _Nullable)socialInfo {
    switch (self.type) {
        case PrefsItemModelTypePnamuContributor:
            return @{
                [ResourcesService localizationForKey:LocalizableKeyTwitter]: [NSURL URLWithString:@"https://twitter.com/Pnamu"],
                [ResourcesService localizationForKey:LocalizableKeyTwitch]: [NSURL URLWithString:@"https://www.twitch.tv/Pnamu"]
            };
        default:
            return nil;
    }
}

- (NSURL * _Nullable)internalWebPageURL {
    switch (self.type) {
        case PrefsItemModelTypePookjwContributor:
            return [NSURL URLWithString:@"https://github.com/pookjw"];
        default:
            return nil;
    }
}

- (NSURL * _Nullable)externalWebPageURL {
    switch (self.type) {
        case PrefsItemModelTypeJoinTestFlight:
            return [NSURL URLWithString:@"https://testflight.apple.com/join/StyyfbHu"];
        default:
            return nil;
    }
}

@end
