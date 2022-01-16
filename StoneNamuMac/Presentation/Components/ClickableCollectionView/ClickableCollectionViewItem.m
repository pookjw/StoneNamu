//
//  SelectedBackgroundCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import "ClickableCollectionViewItem.h"

@implementation ClickableCollectionViewItem

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.appearanceTypes = ClickableCollectionViewItemAppearanceTypeClicked | ClickableCollectionViewItemAppearanceTypeSelected | ClickableCollectionViewItemAppearanceTypeHighlighted;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        self.appearanceTypes = ClickableCollectionViewItemAppearanceTypeClicked | ClickableCollectionViewItemAppearanceTypeSelected | ClickableCollectionViewItemAppearanceTypeHighlighted;
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.view.window"];
    [self removeObserver:self forKeyPath:@"self.view.effectiveAppearance"];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (([object isEqual:self]) && ([keyPath isEqualToString:@"self.view.window"])) {
        [NSNotificationCenter.defaultCenter removeObserver:self
                                                      name:NSWindowDidBecomeMainNotification
                                                    object:nil];
        
        [NSNotificationCenter.defaultCenter removeObserver:self
                                                      name:NSWindowDidResignMainNotification
                                                    object:nil];
        
        if (self.view.window != nil) {
            [NSNotificationCenter.defaultCenter addObserver:self
                                                   selector:@selector(didBecomeMain:)
                                                       name:NSWindowDidBecomeMainNotification
                                                     object:self.view.window];
            
            [NSNotificationCenter.defaultCenter addObserver:self
                                                   selector:@selector(didResignMain:)
                                                       name:NSWindowDidResignMainNotification
                                                     object:self.view.window];
        }
    } else if (([object isEqual:self] && ([keyPath isEqualToString:@"self.view.effectiveAppearance"]))) {
        [self updateBackgroundColor];
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setAttributes];
    [self _bind];
    [self updateBackgroundColor];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (self.appearanceTypes & ClickableCollectionViewItemAppearanceTypeSelected) {
        [self updateBackgroundColor];
    }
}

- (void)setClicked:(BOOL)clicked {
    [self willChangeValueForKey:@"clicked"];
    self->_clicked = clicked;
    [self didChangeValueForKey:@"clicked"];
    
    if (self.appearanceTypes & ClickableCollectionViewItemAppearanceTypeClicked) {
        [self updateBorderColor];
    }
}

- (void)setHighlightState:(NSCollectionViewItemHighlightState)highlightState {
    [super setHighlightState:highlightState];
    
    if (self.appearanceTypes & ClickableCollectionViewItemAppearanceTypeHighlighted) {
        [self updateBackgroundColor];
    }
}

- (void)_setAttributes {
    self.view.wantsLayer = YES;
    self.view.layer.borderWidth = 8.0f;
    self.view.layer.borderColor = NSColor.clearColor.CGColor;
}

- (void)updateBackgroundColor {
    if ((self.isSelected) || (self.highlightState == NSCollectionViewItemHighlightForSelection)) {
        if (self.view.window.isMainWindow) {
            self.view.layer.backgroundColor = NSColor.controlAccentColor.CGColor;
        } else {
            self.view.layer.backgroundColor = NSColor.systemGrayColor.CGColor;
        }
    } else {
        self.view.layer.backgroundColor = nil;
    }
}

- (void)updateBorderColor {
    if ((self.isClicked) && (!self.isSelected) && (!(self.highlightState == NSCollectionViewItemHighlightForSelection))) {
        if (self.view.window.isMainWindow) {
            self.view.layer.borderColor = NSColor.controlAccentColor.CGColor;
        } else {
            self.view.layer.borderColor = NSColor.systemGrayColor.CGColor;
        }
    } else {
        self.view.layer.borderColor = NSColor.clearColor.CGColor;
    }
}

- (void)_bind {
    [self addObserver:self forKeyPath:@"self.view.window" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"self.view.effectiveAppearance" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didChangeSystemColors:)
                                               name:NSSystemColorsDidChangeNotification
                                             object:nil];
}

- (void)didChangeSystemColors:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self updateBackgroundColor];
    }];
}

- (void)didBecomeMain:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self updateBackgroundColor];
    }];
}

- (void)didResignMain:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self updateBackgroundColor];
    }];
}

@end
