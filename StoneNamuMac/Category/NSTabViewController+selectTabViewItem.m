//
//  NSTabViewController+selectTabViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/14/21.
//

#import "NSTabViewController+selectTabViewItem.h"

@implementation NSTabViewController (selectTabViewItem)

- (void)selectTabViewItem:(NSTabViewItem *)tabViewItem {
    NSUInteger index = [self.tabViewItems indexOfObject:tabViewItem];
    self.selectedTabViewItemIndex = index;
}

@end
