//
//  CardDetailsBasicContentConfiguration.h
//  CardDetailsBasicContentConfiguration
//
//  Created by Jinwoo Kim on 8/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsBasicContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) NSString * _Nullable leadingText;
@property (readonly, copy) NSString * _Nullable trailingText;
- (instancetype)initWithLeadingText:(NSString * _Nullable)leadingText trailingText:(NSString * _Nullable)trailingText;
@end

NS_ASSUME_NONNULL_END
