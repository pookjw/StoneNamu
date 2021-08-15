//
//  PrefsRegionHostItemModel.m
//  PrefsRegionHostItemModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "PrefsRegionHostItemModel.h"

@implementation PrefsRegionHostItemModel

- (instancetype)initWithRegionHost:(NSNumber *)regionHost isSelected:(BOOL)isSelected {
    self = [self init];
    
    if (self) {
        self->_regionHost = [regionHost copy];
        self.isSelected = isSelected;
    }
    
    return self;
}

- (void)dealloc {
    [_regionHost release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    PrefsRegionHostItemModel *toCompare = (PrefsRegionHostItemModel *)object;
    
    if (![toCompare isKindOfClass:[PrefsRegionHostItemModel class]]) {
        return NO;
    }
    
    BOOL isRegionHostEqual;
    
    if ([self.regionHost isEqualToString:toCompare.regionHost]) {
        isRegionHostEqual = YES;
    } else if ((self.regionHost == nil) && (toCompare.regionHost == nil)) {
        isRegionHostEqual = YES;
    } else {
        isRegionHostEqual = NO;
    }
    
    return (isRegionHostEqual) && (self.isSelected == toCompare.isSelected);
}

- (NSString * _Nullable)primaryText {
    if (self.regionHost) {
        NSDictionary<NSString *, NSString *> *localizables = blizzardHSAPIRegionsForAPIWithLocalizable();
        return localizables[self.regionHost];
    } else {
        return NSLocalizedString(@"AUTO", @"");
    }
}

- (NSString * _Nullable)secondaryText {
    if (self.regionHost == nil) {
        return NSLocalizedString(@"CARD_LANGUAGE_AUTO_DESCRIPTION", @"");
    } else {
        return nil;
    }
}

@end
