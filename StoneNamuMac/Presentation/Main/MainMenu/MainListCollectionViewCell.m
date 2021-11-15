//
//  MainListCollectionViewCell.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/16/21.
//

#import "MainListCollectionViewCell.h"

@interface MainListCollectionViewCell ()

@end

@implementation MainListCollectionViewCell

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self bind];
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
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didChangeSystemColors:)
                                               name:NSSystemColorsDidChangeNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didBecomeActive:)
                                               name:NSApplicationDidBecomeActiveNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didResignActive:)
                                               name:NSApplicationDidResignActiveNotification
                                             object:nil];
}

- (void)didChangeSystemColors:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self updateBackgroundColor];
    }];
}

- (void)didBecomeActive:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self updateBackgroundColor];
    }];
}

- (void)didResignActive:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        if (self.isSelected) {
            self.view.layer.backgroundColor = NSColor.systemGrayColor.CGColor;
        } else {
            self.view.layer.backgroundColor = nil;
        }
    }];
}

@end
