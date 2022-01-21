//
//  DeckBackgroundBox.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/22/22.
//

#import "DeckBackgroundBox.h"

@implementation DeckBackgroundBox

- (void)configureWithType:(DeckBackgroundBoxType)type {
    switch (type) {
        case DeckBackgroundBoxTypePrimary:
            self.fillColor = NSColor.clearColor;
            break;
        case DeckBackgroundBoxTypeSecondary:
            self.fillColor = NSColor.underPageBackgroundColor;
            break;
        default:
            self.fillColor = nil;
            break;
    }
}

@end
