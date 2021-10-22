//
//  DeckDetailsManaCostGraphContentConfiguration.h
//  DeckDetailsManaCostGraphContentConfiguration
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsManaCostGraphContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) NSNumber *cardManaCost;
@property (readonly, copy) NSNumber *percentage;
@property (readonly, copy) NSNumber *cardCount;
@property (readonly) BOOL isDarkMode;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCost:(NSNumber *)cost percentage:(NSNumber *)percentage cardCount:(NSNumber *)cardCount;
@end

NS_ASSUME_NONNULL_END
