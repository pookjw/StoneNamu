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

+ (SEL)keyMenuItemTriggeredSelector {
    return NSSelectorFromString(@"keyMenuItemTriggered:");
}

+ (NSMenu *)menuForHSDeckFormat:(HSDeckFormat)deckFormat target:(id _Nullable)target {
    NSMutableArray<NSMenuItem *> *itemArray = [NSMutableArray<NSMenuItem *> new];
    NSDictionary<NSString *, NSString *> *dic = [ResourcesService localizationsForHSCardClassForFormat:deckFormat];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        StorableMenuItem *item = [[StorableMenuItem alloc] initWithTitle:obj
                                                                  action:DecksMenuFactory.keyMenuItemTriggeredSelector
                                                           keyEquivalent:@""
                                                                userInfo:@{deckFormat: key}];
        item.target = target;
        
        [itemArray addObject:item];
        [item release];
    }];
    
    [itemArray sortUsingComparator:^NSComparisonResult(StorableMenuItem* obj1, StorableMenuItem* obj2) {
        HSCardClass lhs = HSCardClassFromNSString(obj1.userInfo.allValues.firstObject);
        HSCardClass rhs = HSCardClassFromNSString(obj2.userInfo.allValues.firstObject);
        
        if (lhs > rhs) {
            return NSOrderedDescending;
        } else if (lhs < rhs) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    //
    
    NSMenu *menu = [NSMenu new];
    menu.itemArray = itemArray;
    [itemArray release];
    
    return [menu autorelease];
}

@end
