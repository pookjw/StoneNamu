//
//  NSBox+setSimpleBoxStyle.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import "NSBox+setSimpleBoxStyle.h"

@implementation NSBox (setSimpleBoxStyle)

- (void)setSimpleBoxStyle {
    self.boxType = NSBoxCustom;
    self.borderWidth = 0.0f;
    self.cornerRadius = 0.0f;
    self.titlePosition = NSNoTitle;
}

@end
