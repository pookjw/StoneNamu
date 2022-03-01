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
@property (readonly, copy) HSCardGameModeSlugType hsCardGameModeSlugType;
@property (readonly) BOOL isGold;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCard:(HSCard *)hsCard hsCardGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold;
@end

NS_ASSUME_NONNULL_END
