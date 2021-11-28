//
//  NSSplitViewController+removeSplitViewItemAtIndex.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import "NSSplitViewController+removeSplitViewItemAtIndex.h"

@implementation NSSplitViewController (removeSplitViewItemAtIndex)

- (void)removeSplitViewItemAtIndex:(NSInteger)index {
    NSArray<__kindof NSSplitViewItem *> *splitViewItems = self.splitViewItems;
    
    if (splitViewItems.count <= index) return;
    
    [self removeSplitViewItem:splitViewItems[index]];
}

@end
