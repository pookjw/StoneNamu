//
//  BattlegroundsCardOptionSectionModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/26/22.
//

#import "BattlegroundsCardOptionSectionModel.h"

@implementation BattlegroundsCardOptionSectionModel

- (instancetype)initWithType:(BattlegroundsCardOptionsSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[BattlegroundsCardOptionSectionModel class]]) {
        return NO;
    }
    
    BattlegroundsCardOptionSectionModel *toCompare = (BattlegroundsCardOptionSectionModel *)object;
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}


@end
