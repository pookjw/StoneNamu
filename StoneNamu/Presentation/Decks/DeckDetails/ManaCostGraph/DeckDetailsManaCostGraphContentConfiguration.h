//
//  DeckDetailsManaCostGraphContentConfiguration.h
//  DeckDetailsManaCostGraphContentConfiguration
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsManaCostGraphContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly) NSUInteger cardManaCost;
@property (readonly) float percentage;
@property (readonly) NSUInteger cardCount;
@property (readonly) BOOL isDarkMode;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCost:(NSUInteger)cardManaCost percentage:(float)percentage cardCount:(NSUInteger)cardCount;
@end

NS_ASSUME_NONNULL_END
