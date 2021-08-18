//
//  DecksItemModel.m
//  DecksItemModel
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import "DecksItemModel.h"

@implementation DecksItemModel

- (instancetype)initWithType:(DecksItemModelType)type objectId:(NSManagedObjectID *)objectId {
    self = [self init];
    
    if (self) {
        self->_type = type;
        self->_objectId = [objectId copy];
    }
    
    return self;
}

- (void)dealloc {
    [_objectId release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    DecksItemModel *toCompare = (DecksItemModel *)object;
    
    if (![toCompare isKindOfClass:[DecksItemModel class]]) {
        return NO;
    }
    
    return (self.type == toCompare.type) && ([self.objectId isEqual:toCompare.objectId]);
}

- (NSUInteger)hash {
    return self.type ^ self.objectId.hash;
}

@end
