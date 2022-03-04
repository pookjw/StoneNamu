//
//  NSString+attributedStringWhenHTML.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 1/19/22.
//

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSString (attributedStringWhenHTML)
@property (readonly, nonatomic) NSAttributedString *attributedStringWhenHTML;
//@property (readonly, nonatomic) NSAttributedString *attributedStringWhenHTMLWithClear;
@end

NS_ASSUME_NONNULL_END
