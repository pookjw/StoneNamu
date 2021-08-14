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
        case PrefsItemModelTypeJinwooKimContributor:
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
        case PrefsItemModelTypeJinwooKimContributor:
            return NSLocalizedString(@"JINWOO_KIM", @"");
        case PrefsItemModelTypePnamuContributor:
            return NSLocalizedString(@"PNAMU", @"");
        default:
            return nil;
    }
}

- (NSString * _Nullable)secondaryText {
    switch (self.type) {
        case PrefsItemModelTypeJinwooKimContributor:
            return NSLocalizedString(@"JINWOO_KIM_DESCRIPTION", @"");
        case PrefsItemModelTypePnamuContributor:
            return NSLocalizedString(@"PNAMU_DESCRIPTION", @"");
        default:
            return nil;
    }
}

- (BOOL)hasDisclosure {
    return YES;
}

@end
