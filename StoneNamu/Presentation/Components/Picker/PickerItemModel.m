//
//  PickerItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import "PickerItemModel.h"
#import <StoneNamuCore/StoneNamuCore.h>

@implementation PickerItemModel

- (instancetype)initEmptyWithSectionType:(NSUInteger)sectionType IsSelected:(BOOL)isSelected {
    self = [self init];
    
    if (self) {
        self->_type = PickerItemModelTypeEmpty;
        self->_sectionType = sectionType;
        
        [self->_key release];
        self->_key = nil;
        
        [self->_text release];
        self->_text = nil;
        
        self.selected = isSelected;
    }
    
    return self;
}

- (instancetype)initWithSectionType:(NSUInteger)sectionType key:(NSString *)key text:(NSString *)text isSelected:(BOOL)isSelected {
    self = [self init];
    
    if (self) {
        self->_type = PickerItemModelTypeItems;
        self->_sectionType = sectionType;
        
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
    BOOL sectionType = (self.sectionType == toCompare.sectionType);
    BOOL key = compareNullableValues(self.key, toCompare.key, @selector(isEqualToString:));
    BOOL text = compareNullableValues(self.text, toCompare.text, @selector(isEqualToString:));
    
    return type && sectionType && key && text;
}

- (NSUInteger)hash {
    return self.type ^ self.sectionType ^ self.key.hash ^ self.text.hash;
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        PickerItemModel *_copy = (PickerItemModel *)copy;
        
        _copy->_type = self.type;
        _copy->_sectionType = self.sectionType;
        
        [_copy->_key release];
        _copy->_key = [self.key copyWithZone:zone];
        
        [_copy->_text release];
        _copy->_text = [self.text copyWithZone:zone];
        
        _copy->_selected = self.selected;
    }
    
    return copy;
}

@end
