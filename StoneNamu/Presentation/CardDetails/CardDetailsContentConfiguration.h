//
//  CardDetailsContentConfiguration.h
//  CardDetailsContentConfiguration
//
//  Created by Jinwoo Kim on 8/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsContentConfiguration : NSObject <UIContentConfiguration>
@property (copy) NSString *leadingText;
@property (copy) NSString *trailingText;
- (instancetype)initWithLeadingText:(NSString *)leadingText trailingText:(NSString *)trailingText;
@end

NS_ASSUME_NONNULL_END
