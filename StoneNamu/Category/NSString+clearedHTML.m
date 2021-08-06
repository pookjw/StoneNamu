//
//  NSString+clearedHTML.m
//  NSString+clearedHTML
//
//  Created by Jinwoo Kim on 8/6/21.
//

#import "NSString+clearedHTML.h"
#import <UIKit/UIKit.h>

@implementation NSString (clearedHTML)

- (NSString *)clearedHTML {
    NSDictionary<NSAttributedStringDocumentReadingOptionKey, id> *options = @{
        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
    };
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    
    NSRange totalRange = NSMakeRange(0, attr.length);
    [attr removeAttribute:NSForegroundColorAttributeName range:totalRange];
    [attr removeAttribute:NSFontAttributeName range:totalRange];
    
    NSString *result = attr.string;
    [attr release];
    
    return result;
}

@end
