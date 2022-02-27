//
//  BattlegroundsCardOptionsMenuDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BattlegroundsCardOptionsMenu;

@protocol BattlegroundsCardOptionsMenuDelegate <NSObject>
- (void)battlegroundsCardOptionsMenu:(BattlegroundsCardOptionsMenu *)menu changedOption:(NSDictionary<NSString *, NSSet<NSString *> *> *)options;
- (void)battlegroundsCardOptionsMenu:(BattlegroundsCardOptionsMenu *)menu defaultOptionsAreNeedWithSender:(NSMenuItem *)sender;
@end

NS_ASSUME_NONNULL_END
