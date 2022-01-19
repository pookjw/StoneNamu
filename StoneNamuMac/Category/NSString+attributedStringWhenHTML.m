//
//  NSString+attributedStringWhenHTML.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 1/19/22.
//

#import "NSString+attributedStringWhenHTML.h"

@implementation NSString (attributedStringWhenHTML)

- (NSAttributedString *)attributedStringWhenHTML {
    NSDictionary<NSAttributedStringDocumentReadingOptionKey, id> *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithUnsignedInteger:NSUTF8StringEncoding]};
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    
    return [attributedString autorelease];
}

//- (NSAttributedString *)attributedStringWhenHTMLWithClear {
//    NSMutableAttributedString *mutableAttributedString = [self.attributedStringWhenHTML mutableCopy];
//    
//    NSRange totalRange = NSMakeRange(0, mutableAttributedString.length);
//    [mutableAttributedString removeAttribute:NSForegroundColorAttributeName range:totalRange];
//    [mutableAttributedString removeAttribute:NSFontAttributeName range:totalRange];
//    
//    return [mutableAttributedString autorelease];
//}

@end
