//
//  ClickableCollectionView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/19/21.
//

#import "ClickableCollectionView.h"

@interface ClickableCollectionView ()
@property (readonly, nonatomic) id<ClickableCollectionViewDelegate> _Nullable clickedItem;
@end

@implementation ClickableCollectionView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self _bind];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self _bind];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        [self _bind];
    }
    
    return self;
}

- (void)dealloc {
    [_clickedIndexPath release];
    [super dealloc];
}

- (void)rightMouseDown:(NSEvent *)event {
    NSIndexPath * _Nullable indexPath = [self indexPathForItemAtPoint:[self convertPoint:event.locationInWindow fromView:nil]];
    
    if (indexPath != nil) {
        [self->_clickedIndexPath release];
        self->_clickedIndexPath = nil;
        self->_clickedIndexPath = [indexPath copy];
    }
    
    [super rightMouseDown:event];
}

- (id<ClickableCollectionViewDelegate> _Nullable)clickedItem {
    id<ClickableCollectionViewDelegate> _Nullable item = (id<ClickableCollectionViewDelegate>)[self itemAtIndexPath:self.clickedIndexPath];
    
    if ((item == nil) || (![item conformsToProtocol:@protocol(ClickableCollectionViewDelegate)])) {
        return nil;
    } else {
        return item;
    }
}

- (void)_bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(menuDidBeginTracking:)
                                               name:NSMenuDidBeginTrackingNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(menuDidEndTracking:)
                                               name:NSMenuDidEndTrackingNotification
                                             object:nil];
}

- (void)menuDidBeginTracking:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        id<ClickableCollectionViewDelegate> _Nullable clickedItem = self.clickedItem;
        
        if (clickedItem != nil) {
            [clickedItem clickableCollectionView:self didClick:YES];
        }
    }];
}

- (void)menuDidEndTracking:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        id<ClickableCollectionViewDelegate> _Nullable clickedItem = self.clickedItem;
        
        if (clickedItem != nil) {
            [clickedItem clickableCollectionView:self didClick:NO];
        }
        
        [self->_clickedIndexPath release];
        self->_clickedIndexPath = nil;
    }];
}

@end
