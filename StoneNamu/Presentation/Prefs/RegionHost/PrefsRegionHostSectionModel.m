//
//  PrefsRegionSectionModel.m
//  PrefsRegionSectionModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "PrefsRegionHostSectionModel.h"

@implementation PrefsRegionHostSectionModel

- (instancetype)initWithType:(PrefsRegionHostSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    PrefsRegionHostSectionModel *toCompare = (PrefsRegionHostSectionModel *)object;
    
    if (![toCompare isKindOfClass:[PrefsRegionHostSectionModel class]]) {
        return NO;
    }
    
    return self.type == toCompare.type;
}

@end
