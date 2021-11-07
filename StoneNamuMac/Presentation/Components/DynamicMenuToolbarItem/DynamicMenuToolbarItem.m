//
//  DynamicMenuToolbarItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/31/21.
//

#import "DynamicMenuToolbarItem.h"

@implementation DynamicMenuToolbarItem

- (NSMenuItem *)menuFormRepresentation {
    NSMenuItem *item = [super menuFormRepresentation];
    item.title = self.title;
    item.image = self.image;
    
    return item;
}

@end
