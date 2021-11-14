//
//  PrefsRegionHostItemModel.m
//  PrefsRegionHostItemModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "PrefsRegionHostItemModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation PrefsRegionHostItemModel

- (instancetype)initWithRegionHost:(NSNumber *)regionHost isSelected:(BOOL)isSelected {
    self = [self init];
    
    if (self) {
        [self->_regionHost release];
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
    
    return (isRegionHostEqual);
}

- (NSUInteger)hash {
    return self.regionHost.hash;
}

- (NSString * _Nullable)primaryText {
    if (self.regionHost) {
        return [ResourcesService localizationForBlizzardAPIRegionHost:BlizzardAPIRegionHostFromNSStringForAPI(self.regionHost)];
    } else {
        return [ResourcesService localizationForKey:LocalizableKeyAuto];
    }
}

- (NSString * _Nullable)secondaryText {
    if (self.regionHost == nil) {
        return [ResourcesService localizationForKey:LocalizableKeyServerAutoDescription];
    } else {
        return nil;
    }
}

@end
