//
//  ClickableCollectionView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/19/21.
//

#import "ClickableCollectionView.h"
#import "ClickableCollectionViewItem.h"

@interface ClickableCollectionView ()
@property (readonly, nonatomic) ClickableCollectionViewItem * _Nullable clickedItem;
@property (copy) NSIndexPath * _Nullable trackingIndexPath;
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
    [self removeObserver:self forKeyPath:@"selectionIndexPaths"];
    [self removeObserver:self forKeyPath:@"clickedIndexPath"];
    [_clickedIndexPath release];
    [_trackingIndexPath release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self]) {
        if (([keyPath isEqualToString:@"selectionIndexPaths"]) || ([keyPath isEqualToString:@"clickedIndexPath"])) {
            [self willChangeValueForKey:@"interactingIndexPaths"];
            [self didChangeValueForKey:@"interactingIndexPaths"];
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)rightMouseDown:(NSEvent *)event {
    NSIndexPath * _Nullable indexPath = [self indexPathForItemAtPoint:[self convertPoint:event.locationInWindow fromView:nil]];
    
    if (indexPath != nil) {
        [self willChangeValueForKey:@"clickedIndexPath"];
        [self->_clickedIndexPath release];
        self->_clickedIndexPath = [indexPath copy];
        [self didChangeValueForKey:@"clickedIndexPath"];
    }
    
    [super rightMouseDown:event];
}

- (ClickableCollectionViewItem * _Nullable)clickedItem {
    if (self.clickedIndexPath == nil) return nil;
    
    ClickableCollectionViewItem * _Nullable item = (ClickableCollectionViewItem *)[self itemAtIndexPath:self.clickedIndexPath];
    
    if ((item == nil) || (![item isKindOfClass:[ClickableCollectionViewItem class]])) {
        return nil;
    } else {
        return item;
    }
}

- (NSSet<NSIndexPath *> *)interactingIndexPaths {
    NSIndexPath * _Nullable clickedIndexPath = self.clickedIndexPath;
    NSSet<NSIndexPath *> *selectionIndexPaths = self.selectionIndexPaths;
    
    if ((clickedIndexPath != nil) && (![selectionIndexPaths containsObject:clickedIndexPath])) {
        return [NSSet setWithObject:clickedIndexPath];
    } else {
        return selectionIndexPaths;
    }
}

- (void)_bind {
    [self addObserver:self forKeyPath:@"selectionIndexPaths" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"clickedIndexPath" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
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
        id _Nullable menuObject = notification.object;
        
        if ((menuObject == nil) || (![menuObject isEqual:self.menu])) {
            return;
        }
        
        ClickableCollectionViewItem * _Nullable clickedItem = self.clickedItem;
        
        if (clickedItem != nil) {
            self.trackingIndexPath = self.clickedIndexPath;
            [self setClickedToAllItems:NO];
            clickedItem.clicked = YES;
        }
    }];
}

- (void)menuDidEndTracking:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        id _Nullable menuObject = notification.object;
        
        if ((menuObject == nil) || (![menuObject isEqual:self.menu])) {
            return;
        }
        
        /*
         Normally, if you click right-mouse-down, cycle will be
         rightMouseDown: -> menuDidBeginTracking: -> menuDidEndTracking:
         When this cycle ends, we need to clear clickedIndexPath.
         
         But when NSMenu is activated and click right-mouse-down again, cycle will be
         rightMouseDown: -> menuDidEndTracking: -> menuDidBeginTracking: -> menuDidEndTracking:
         in this cycle, we don't want to clear clickedIndexPath at first call of menuDidEndTracking:. To prevent this, we have to check trackingIndexPath.
         */
        if ((self.trackingIndexPath != nil) && ([self.trackingIndexPath isEqual:self.clickedIndexPath])) {
            [self willChangeValueForKey:@"clickedIndexPath"];
            [self->_clickedIndexPath release];
            self->_clickedIndexPath = nil;
            [self didChangeValueForKey:@"clickedIndexPath"];
        }
        
        [self setClickedToAllItems:NO];
    }];
}

- (void)setClickedToAllItems:(BOOL)isClicked {
    [self.visibleItems enumerateObjectsUsingBlock:^(NSCollectionViewItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ClickableCollectionViewItem *item = (ClickableCollectionViewItem *)obj;
        
        if ([item isKindOfClass:[ClickableCollectionViewItem class]]) {
            item.clicked = isClicked;
        }
    }];
}

@end
