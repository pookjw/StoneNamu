//
//  CardOptionsMenu.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "CardOptionsMenu.h"

@interface CardOptionsMenu ()
@property (weak) id<CardOptionsMenuDelegate> cardOptionsMenuDelegate;

@property (retain) NSMenuItem *optionsMenuItem;
@property (retain) CardOptionsMenuItem *optionTypeTextFilterItem;
@property (retain) CardOptionsMenuItem *optionTypeSetItem;
@property (retain) CardOptionsMenuItem *optionTypeClassItem;
@property (retain) CardOptionsMenuItem *optionTypeManaCostItem;
@property (retain) CardOptionsMenuItem *optionTypeAttackItem;
@property (retain) CardOptionsMenuItem *optionTypeHealthItem;
@property (retain) CardOptionsMenuItem *optionTypeCollectibleItem;
@property (retain) CardOptionsMenuItem *optionTypeRarityItem;
@property (retain) CardOptionsMenuItem *optionTypeTypeItem;
@property (retain) CardOptionsMenuItem *optionTypeMinionTypeItem;
@property (retain) CardOptionsMenuItem *optionTypeSpellSchoolItem;
@property (retain) CardOptionsMenuItem *optionTypeKeywordItem;
@property (retain) CardOptionsMenuItem *optionTypeGameModeItem;
@property (retain) CardOptionsMenuItem *optionTypeSortItem;
@property (retain) NSMutableDictionary<NSString *, NSString *> *options;
@end

@implementation CardOptionsMenu

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSString *> *)options cardOptionsMenuDelegate:(id<CardOptionsMenuDelegate>)cardOptionsMenuDelegate {
    self = [self init];
    
    if (self) {
        NSMutableDictionary<NSString *, NSString *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        self.cardOptionsMenuDelegate = cardOptionsMenuDelegate;
        [self configureOptionsMenu];
    }
    
    return self;
}

- (void)dealloc {
    [_optionsMenuItem release];
    [_optionTypeTextFilterItem release];
    [_optionTypeSetItem release];
    [_optionTypeClassItem release];
    [_optionTypeManaCostItem release];
    [_optionTypeAttackItem release];
    [_optionTypeHealthItem release];
    [_optionTypeCollectibleItem release];
    [_optionTypeRarityItem release];
    [_optionTypeTypeItem release];
    [_optionTypeMinionTypeItem release];
    [_optionTypeSpellSchoolItem release];
    [_optionTypeKeywordItem release];
    [_optionTypeGameModeItem release];
    [_optionTypeSortItem release];
    
    [_options release];
    [super dealloc];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *,NSString *> *)options {
    
}

- (void)configureOptionsMenu {
    NSMenuItem *optionsMenuItem = [NSMenuItem new];
    self.optionsMenuItem = optionsMenuItem;
    
    NSMenu *optionsSubMenu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"CARD_OPTIONS_TITLE_SHORT", @"")];
    optionsMenuItem.submenu = optionsSubMenu;
    
    [self insertItem:optionsMenuItem atIndex:3];
    [optionsMenuItem release];
    [optionsSubMenu release];
}

@end
