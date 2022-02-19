//
//  CardOptionItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionItemModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation CardOptionItemModel

- (instancetype)initWithOptionType:(BlizzardHSAPIOptionType)optionType slugsAndNames:(NSDictionary<NSString *, NSString *> * _Nullable)slugsAndNames showsEmptyRow:(BOOL)showsEmptyRow comparator:(NSComparisonResult (^ _Nullable)(NSString *, NSString *))comparator title:(NSString *)title accessoryText:(NSString *)accessoryText toolTip:(NSString *)toolTip {
    self = [self init];
    
    if (self) {
        self.values = nil;
        
        [self->_optionType release];
        self->_optionType = [optionType copy];
        
        [self->_slugsAndNames release];
        self->_slugsAndNames = [slugsAndNames copy];
        
        self->_showsEmptyRow = showsEmptyRow;
        
        [self->_comparator release];
        self->_comparator = [comparator copy];
        
        [self->_title release];
        self->_title = [title copy];
        
        self.accessoryText = accessoryText;
        
        [self->_toolTip release];
        self->_toolTip = [toolTip copy];
    }
    
    return self;
}

- (void)dealloc {
    [_values release];
    [_optionType release];
    [_slugsAndNames release];
    [_comparator release];
    [_title release];
    [_accessoryText release];
    [_toolTip release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardOptionItemModel class]]) {
        return NO;
    }
    
    CardOptionItemModel *toCompare = (CardOptionItemModel *)object;
    
    BOOL optionType = compareNullableValues(self.optionType, toCompare.optionType, @selector(isEqualToString:));
    
    return (optionType);
}

- (NSUInteger)hash {
    return self.optionType.hash;
}

@end
