//
//  PrefsLocaleSectionModel.m
//  PrefsLocaleSectionModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "PrefsLocaleSectionModel.h"

@implementation PrefsLocaleSectionModel

- (instancetype)initWithType:(PrefsLocaleSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    PrefsLocaleSectionModel *toCompare = (PrefsLocaleSectionModel *)object;
    
    if (![toCompare isKindOfClass:[PrefsLocaleSectionModel class]]) {
        return NO;
    }
    
    return self.type == toCompare.type;
}

@end
