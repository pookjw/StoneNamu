//
//  PrefsLocaleItemModel.m
//  PrefsLocaleItemModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "PrefsLocaleItemModel.h"

@implementation PrefsLocaleItemModel

- (instancetype)initWithLocale:(BlizzardHSAPILocale _Nullable)locale isSelected:(BOOL)isSelected {
    self = [self init];
    
    if (self) {
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
    
    return (self.locale == toCompare.locale) && (self.isSelected == toCompare.isSelected);
}

- (NSString * _Nullable)primaryText {
    if (self.locale) {
        NSDictionary<NSString *, NSString *> *localizables = blizzardHSAPILocalesWithLocalizable();
        return localizables[self.locale];
    } else {
        return NSLocalizedString(@"AUTO", @"");
    }
}

- (NSString * _Nullable)secondaryText {
    return @"Test";
}

@end
