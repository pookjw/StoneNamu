//
//  DeckDetailsSectionModel.m
//  DeckDetailsSectionModel
//
//  Created by Jinwoo Kim on 8/20/21.
//

#import "DeckDetailsSectionModel.h"

@implementation DeckDetailsSectionModel

- (instancetype)initWithType:(DeckDetailsSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (NSUInteger)hash {
    return self.type;
}

@end
