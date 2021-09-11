//
//  DeckImageRenderServiceCardContentConfiguration.h
//  DeckImageRenderServiceCardContentConfiguration
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import <UIKit/UIKit.h>
#import "HSCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckImageRenderServiceCardContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) HSCard *hsCard;
@property (readonly, retain) UIImage *hsCardImage;
@property (readonly) NSUInteger hsCardCount;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCard:(HSCard *)hsCard hsCardImage:(UIImage *)hsCardImage hsCardCount:(NSUInteger)hsCardCount;
@end

NS_ASSUME_NONNULL_END
