//
//  MainListSectionModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/16/21.
//

#import "MainListSectionModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation MainListSectionModel

- (instancetype)initWithType:(MainListSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (NSString *)title {
    switch (self.type) {
        case MainListSectionModelTypeCards:
            return [ResourcesService localizationForKey:LocalizableKeyCards];
        case MainListSectionModelTypeDecks:
            return [ResourcesService localizationForKey:LocalizableKeyDecks];
        default:
            return @"";
    }
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[MainListSectionModel class]]) {
        return NO;
    }
    
    MainListSectionModel *toCompare = (MainListSectionModel *)object;
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

@end
