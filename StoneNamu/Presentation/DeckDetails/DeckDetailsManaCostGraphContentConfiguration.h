//
//  DeckDetailsManaCostGraphContentConfiguration.h
//  DeckDetailsManaCostGraphContentConfiguration
//
//  Created by Jinwoo Kim on 8/24/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsManaCostGraphContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) NSDictionary<NSNumber *, NSNumber *> *manaDictionary;
- (instancetype)initWithManaDictionary:(NSDictionary<NSNumber *, NSNumber *> *)manaDictionary;
@end

NS_ASSUME_NONNULL_END
