//
//  DecksMenuFactory.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import "DecksMenuFactory.h"
#import "StorableMenuItem.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation DecksMenuFactory

- (void)dealloc {
    [_slugsAndNames release];
    [_slugsAndIds release];
    [super dealloc];
}

- (SEL)keyMenuItemTriggeredSelector {
    return NSSelectorFromString(@"keyMenuItemTriggered:");
}

- (NSMenu *)menuForHSDeckFormat:(HSDeckFormat)deckFormat target:(id _Nullable)target {
    NSMutableArray<NSMenuItem *> *itemArray = [NSMutableArray<NSMenuItem *> new];
    NSDictionary<NSString *, NSString *> *dic = self.slugsAndNames[deckFormat];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        StorableMenuItem *item = [[StorableMenuItem alloc] initWithTitle:obj
                                                                  action:self.keyMenuItemTriggeredSelector
                                                           keyEquivalent:@""
                                                                userInfo:@{deckFormat: key}];
        item.target = target;
        
        [itemArray addObject:item];
        [item release];
    }];
    
    [itemArray sortUsingComparator:^NSComparisonResult(StorableMenuItem* obj1, StorableMenuItem* obj2) {
        return [obj1.title compare:obj2.title];
    }];
    
    //
    
    NSMenu *menu = [NSMenu new];
    menu.itemArray = itemArray;
    [itemArray release];
    
    return [menu autorelease];
}

@end
