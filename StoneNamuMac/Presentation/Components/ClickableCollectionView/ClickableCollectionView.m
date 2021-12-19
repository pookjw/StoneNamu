//
//  ClickableCollectionView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/19/21.
//

#import "ClickableCollectionView.h"

@implementation ClickableCollectionView

- (void)rightMouseDown:(NSEvent *)event {
    NSIndexPath * _Nullable indexPath = [self indexPathForItemAtPoint:[self convertPoint:event.locationInWindow fromView:nil]];
    
    if (indexPath != nil) {
        [self selectItemsAtIndexPaths:[self.selectionIndexPaths setByAddingObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
    }
    
    [super rightMouseDown:event];
}

@end
