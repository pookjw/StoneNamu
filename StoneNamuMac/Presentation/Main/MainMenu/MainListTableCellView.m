//
//  MainListTableCellView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import "MainListTableCellView.h"

@implementation MainListTableCellView

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearContents];
}

- (void)clearContents {
    self.imageView.image = nil;
    self.textField.stringValue = @"";
}

@end
