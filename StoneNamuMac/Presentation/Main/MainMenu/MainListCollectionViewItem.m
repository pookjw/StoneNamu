//
//  MainListCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/16/21.
//

#import "MainListCollectionViewItem.h"

@implementation MainListCollectionViewItem

- (void)awakeFromNib {
    [super awakeFromNib];
    [self clearContents];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearContents];
}

- (void)clearContents {
    self.imageView.image = nil;
    self.textField.stringValue = @"";
}

@end
