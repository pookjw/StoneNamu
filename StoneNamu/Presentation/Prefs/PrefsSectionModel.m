//
//  PrefsSectionModel.m
//  PrefsSectionModel
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import "PrefsSectionModel.h"

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

- (NSString * _Nullable )headerText {
    switch (self.type) {
        case PrefsSectionModelTypeSearchPrefSelection:
            return NSLocalizedString(@"SEARCH", @"");
        case PrefsSectionModelContributors:
            return NSLocalizedString(@"CONTRIBUTORS", @"");
        default:
            return nil;
    }
}

- (NSString * _Nullable)footerText {
    switch (self.type) {
        case PrefsSectionModelContributors:
            return nil;
        default:
            return nil;
    }
}

@end
