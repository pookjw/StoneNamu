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
        self.headerText = nil;
        self->_type = type;
    }
    
    return self;
}

- (void)dealloc {
    [_headerText release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    DeckDetailsSectionModel *toCompare = (DeckDetailsSectionModel *)object;
    
    if (![toCompare isKindOfClass:[DeckDetailsSectionModel class]]) {
        return NO;
    }
    
    return (self.type == toCompare.type) &&
    (((self.headerText == nil) && (toCompare.headerText == nil)) || [self.headerText isEqualToString:toCompare.headerText]);
}

- (NSUInteger)hash {
    return self.type ^ self.headerText.hash;
}

@end
