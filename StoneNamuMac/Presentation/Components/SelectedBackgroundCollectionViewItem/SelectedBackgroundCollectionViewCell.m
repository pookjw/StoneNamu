//
//  SelectedBackgroundCollectionViewCell.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import "SelectedBackgroundCollectionViewCell.h"

@implementation SelectedBackgroundCollectionViewCell

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.view.window"];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (([object isEqual:self]) && ([keyPath isEqualToString:@"self.view.window"])) {
        [NSNotificationCenter.defaultCenter removeObserver:self];
        
        if (self.view.window != nil) {
            [NSNotificationCenter.defaultCenter addObserver:self
                                                   selector:@selector(didChangeSystemColors:)
                                                       name:NSSystemColorsDidChangeNotification
                                                     object:nil];
            
            [NSNotificationCenter.defaultCenter addObserver:self
                                                   selector:@selector(didBecomeMain:)
                                                       name:NSWindowDidBecomeMainNotification
                                                     object:self.view.window];
            
            [NSNotificationCenter.defaultCenter addObserver:self
                                                   selector:@selector(didResignMain:)
                                                       name:NSWindowDidResignMainNotification
                                                     object:self.view.window];
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self bind];
    [self updateBackgroundColor];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateBackgroundColor];
}

- (void)setAttributes {
    self.view.wantsLayer = YES;
}

- (void)updateBackgroundColor {
    if (self.isSelected) {
        self.view.layer.backgroundColor = NSColor.controlAccentColor.CGColor;
    } else {
        self.view.layer.backgroundColor = nil;
    }
}

- (void)bind {
    [self addObserver:self forKeyPath:@"self.view.window" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
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
        if (self.isSelected) {
            self.view.layer.backgroundColor = NSColor.systemGrayColor.CGColor;
        } else {
            self.view.layer.backgroundColor = nil;
        }
    }];
}

@end
