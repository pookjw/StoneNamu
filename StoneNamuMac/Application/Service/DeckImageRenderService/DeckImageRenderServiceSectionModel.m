//
//  DeckImageRenderServiceSectionModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import "DeckImageRenderServiceSectionModel.h"

@implementation DeckImageRenderServiceSectionModel

- (instancetype)initWithType:(DeckImageRenderServiceSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    DeckImageRenderServiceSectionModel *toCompare = (DeckImageRenderServiceSectionModel *)object;
    
    if (![toCompare isKindOfClass:[DeckImageRenderServiceSectionModel class]]) {
        return NO;
    }
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

@end
