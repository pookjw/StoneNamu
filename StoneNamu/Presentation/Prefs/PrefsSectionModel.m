//
//  PrefsSectionModel.m
//  PrefsSectionModel
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import "PrefsSectionModel.h"
#import "NSBundle+BuildInfo.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation PrefsSectionModel

- (instancetype)initWithType:(PrefsSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    PrefsSectionModel *toCompare = (PrefsSectionModel *)object;
    
    if (![toCompare isKindOfClass:[PrefsSectionModel class]]) {
        return NO;
    }
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

- (NSString * _Nullable )headerText {
    switch (self.type) {
        case PrefsSectionModelTypeSearchPrefSelection:
            return [ResourcesService localizationForKey:LocalizableKeySearch];
        case PrefsSectionModelTypeData:
            return [ResourcesService localizationForKey:LocalizableKeyData];
        case PrefsSectionModelMiscellaneous:
            return [ResourcesService localizationForKey:LocalizableKeyMiscellaneous];
        case PrefsSectionModelContributors:
            return [ResourcesService localizationForKey:LocalizableKeyContributors];
        default:
            return nil;
    }
}

- (NSString * _Nullable)footerText {
    switch (self.type) {
        case PrefsSectionModelContributors: {
            NSString *appName = [ResourcesService localizationForKey:LocalizableKeyAppName];
            NSString *version = NSBundle.mainBundle.releaseVersionString;
            NSString *build = NSBundle.mainBundle.buildVersionString;
            return [NSString stringWithFormat:@"%@ (%@-%@)", appName, version, build];
        }
        default:
            return nil;
    }
}

@end
