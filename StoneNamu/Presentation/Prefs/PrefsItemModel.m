//
//  PrefsItemModel.m
//  PrefsItemModel
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import "PrefsItemModel.h"

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

- (UIImage * _Nullable)primaryImage {
    switch (self.type) {
        case PrefsItemModelTypeLocaleSelection:
            return [UIImage systemImageNamed:@"textformat"];
        case PrefsItemModelTypeRegionSelection:
            return [UIImage systemImageNamed:@"globe"];
        case PrefsItemModelTypeDeleteAllCaches:
            return [UIImage systemImageNamed:@"trash"];
        case PrefsItemModelTypePookjwContributor:
            return [UIImage imageNamed:@"pookjw"];
        case PrefsItemModelTypePnamuContributor:
            return [UIImage imageNamed:@"pnamu"];
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

- (NSURL * _Nullable)singleWebPageURL {
    switch (self.type) {
        case PrefsItemModelTypePookjwContributor:
            return [NSURL URLWithString:@"https://github.com/pookjw"];
        default:
            return nil;
    }
}

@end
