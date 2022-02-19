//
//  PickerItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import "PickerItemModel.h"
#import <StoneNamuCore/StoneNamuCore.h>

@implementation PickerItemModel

- (instancetype)initEmptyWithIsSelected:(BOOL)isSelected {
    self = [self init];
    
    if (self) {
        self->_type = PickerItemModelTypeEmpty;
        
        [self->_key release];
        self->_key = nil;
        
        [self->_text release];
        self->_text = nil;
        
        self.selected = isSelected;
    }
    
    return self;
}

- (instancetype)initWithKey:(NSString *)key text:(NSString *)text isSelected:(BOOL)isSelected {
    self = [self init];
    
    if (self) {
        self->_type = PickerItemModelTypeItems;
        
        [self->_key release];
        self->_key = [key copy];
        
        [self->_text release];
        self->_text = [text copy];
        
        self.selected = isSelected;
    }
    
    return self;
}

- (void)dealloc {
    [_key release];
    [_text release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    PickerItemModel *toCompare = (PickerItemModel *)object;
    
    if (![toCompare isKindOfClass:[PickerItemModel class]]) {
        return NO;
    }
    
    BOOL type = (self.type == toCompare.type);
    BOOL key = compareNullableValues(self.key, toCompare.key, @selector(isEqualToString:));
    BOOL text = compareNullableValues(self.text, toCompare.text, @selector(isEqualToString:));
    
    return type && key && text;
}

- (NSUInteger)hash {
    return self.type ^ self.key.hash ^ self.text.hash;
}

@end
