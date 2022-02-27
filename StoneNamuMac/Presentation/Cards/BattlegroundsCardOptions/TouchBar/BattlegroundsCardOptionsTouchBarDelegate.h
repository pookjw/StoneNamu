//
//  BattlegroundsCardOptionsTouchBarDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BattlegroundsCardOptionsTouchBar;

@protocol BattlegroundsCardOptionsTouchBarDelegate <NSObject>
- (void)battlegroundsCardOptionsTouchBar:(BattlegroundsCardOptionsTouchBar *)touchBar changedOption:(NSDictionary<NSString *, NSSet<NSString *> *> *)options;
@end

NS_ASSUME_NONNULL_END
