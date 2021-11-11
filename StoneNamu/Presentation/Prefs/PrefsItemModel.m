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
            return NSLocalizedString(@"LOCALE", @"");
        case PrefsItemModelTypeRegionSelection:
            return NSLocalizedString(@"REGION", @"");
        case PrefsItemModelTypeDeleteAllCaches:
            return NSLocalizedString(@"DELETE_ALL_CACHES", @"");
        case PrefsItemModelTypeDeleteAllLocalDecks:
            return @"Remove All LocalDecks";
        case PrefsItemModelTypeJoinTestFlight:
            return NSLocalizedString(@"JOIN_TESTFLIGHT", @"");
        case PrefsItemModelTypePookjwContributor:
            return NSLocalizedString(@"POOKJW", @"");
        case PrefsItemModelTypePnamuContributor:
            return NSLocalizedString(@"PNAMU", @"");
        default:
            return nil;
    }
}

- (NSString * _Nullable)secondaryText {
    switch (self.type) {
        case PrefsItemModelTypePookjwContributor:
            return NSLocalizedString(@"POOKJW_DESCRIPTION", @"");
        case PrefsItemModelTypePnamuContributor:
            return NSLocalizedString(@"PNAMU_DESCRIPTION", @"");
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
                NSLocalizedString(@"TWITTER", @""): [NSURL URLWithString:@"https://twitter.com/Pnamu"],
                NSLocalizedString(@"TWITCH", @""): [NSURL URLWithString:@"https://www.twitch.tv/Pnamu"],
                NSLocalizedString(@"YOUTUBE", @""): [NSURL URLWithString:@"https://www.youtube.com/c/Pnamu"]
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
