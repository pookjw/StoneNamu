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
@property (readonly) BOOL isDarkMode;
- (instancetype)initWithCost:(NSNumber *)cost percentage:(NSNumber *)percentage;
@end

NS_ASSUME_NONNULL_END
