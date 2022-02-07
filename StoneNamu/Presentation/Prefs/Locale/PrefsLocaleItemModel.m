//
//  PrefsLocaleItemModel.m
//  PrefsLocaleItemModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "PrefsLocaleItemModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation PrefsLocaleItemModel

- (instancetype)initWithLocale:(BlizzardHSAPILocale _Nullable)locale isSelected:(BOOL)isSelected {
    self = [self init];
    
    if (self) {
        [self->_locale release];
        self->_locale = [locale copy];
        self.isSelected = isSelected;
    }
    
    return self;
}

- (void)dealloc {
    [_locale release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    PrefsLocaleItemModel *toCompare = (PrefsLocaleItemModel *)object;
    
    if (![toCompare isKindOfClass:[PrefsLocaleItemModel class]]) {
        return NO;
    }
    
    BOOL isLocaleEqual = compareNullableValues(self.locale, toCompare.locale, @selector(isEqualToString:));
    
    return (isLocaleEqual);
}

- (NSUInteger)hash {
    return self.locale.hash;
}

- (NSString * _Nullable)primaryText {
    if (self.locale) {
        return [ResourcesService localizationForBlizzardHSAPILocale:self.locale];
    } else {
        return [ResourcesService localizationForKey:LocalizableKeyAuto];
    }
}

- (NSString * _Nullable)secondaryText {
    if (self.locale == nil) {
        return [ResourcesService localizationForKey:LocalizableKeyCardLanguageAutoDescription];
    } else {
        return nil;
    }
}

@end
