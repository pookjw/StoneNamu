//
//  BattlegroundsCardOptionItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/26/22.
//

#import "BattlegroundsCardOptionItemModel.h"

@implementation BattlegroundsCardOptionItemModel

- (instancetype)initWithOptionType:(BlizzardHSAPIOptionType)optionType slugsAndNames:(NSDictionary<NSNumber *, NSDictionary<NSString *, NSString *> *> * _Nullable)slugsAndNames sectionHeaderTexts:(NSDictionary<NSNumber *, NSString *> * _Nullable)sectionHeaderTexts showsEmptyRow:(BOOL)showsEmptyRow allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^ _Nullable)(NSString *, NSString *))comparator title:(NSString *)title accessoryText:(NSString * _Nullable)accessoryText toolTip:(NSString *)toolTip {
    self = [self init];
    
    if (self) {
        self.values = nil;
        
        [self->_optionType release];
        self->_optionType = [optionType copy];
        
        [self->_slugsAndNames release];
        self->_slugsAndNames = [slugsAndNames copy];
        
        [self->_sectionHeaderTexts release];
        self->_sectionHeaderTexts = [sectionHeaderTexts copy];
        
        self->_showsEmptyRow = showsEmptyRow;
        self->_allowsMultipleSelection = allowsMultipleSelection;
        
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
    [_sectionHeaderTexts release];
    [_comparator release];
    [_title release];
    [_accessoryText release];
    [_toolTip release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[BattlegroundsCardOptionItemModel class]]) {
        return NO;
    }
    
    BattlegroundsCardOptionItemModel *toCompare = (BattlegroundsCardOptionItemModel *)object;
    
    BOOL optionType = compareNullableValues(self.optionType, toCompare.optionType, @selector(isEqualToString:));
    
    return (optionType);
}

- (NSUInteger)hash {
    return self.optionType.hash;
}

- (NSDictionary<NSString *,NSString *> * _Nullable )allSlugsAndNames {
    if (self.slugsAndNames == nil) return nil;
    
    NSDictionary<NSString *, NSString *> * __block allSlugsAndNames = [NSDictionary<NSString *, NSString *> new];
    
    [self.slugsAndNames.allValues enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary<NSString *, NSString *> * oldAllSlugsAndNames = allSlugsAndNames;
        allSlugsAndNames = [[oldAllSlugsAndNames dictionaryByCombiningWithDictionary:obj shouldOverride:NO] retain];
        [oldAllSlugsAndNames release];
    }];
    
    return [allSlugsAndNames autorelease];
}

@end
