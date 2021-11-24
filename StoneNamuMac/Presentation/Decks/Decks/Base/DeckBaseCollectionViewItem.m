//
//  DeckBaseCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import "DeckBaseCollectionViewItem.h"

@implementation DeckBaseCollectionViewItem

- (void)awakeFromNib {
    [super awakeFromNib];
    [self clearContents];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearContents];
}

- (void)configureWithText:(NSString *)text {
    self.textField.stringValue = text;
}

- (void)clearContents {
    self.textField.stringValue = @"";
}

@end
