//
//  CardDetailsChildContentConfiguration.h
//  CardDetailsChildContentConfiguration
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsChildContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) HSCard *hsCard;
@property (readonly, copy) NSURL * _Nullable imageURL;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCard:(HSCard *)hsCard imageURL:(NSURL * _Nullable)imageURL;
@end

NS_ASSUME_NONNULL_END
