//
//  BattlegroundsCardOptionsTouchBar.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import <Cocoa/Cocoa.h>
#import "BattlegroundsCardOptionsTouchBarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface BattlegroundsCardOptionsTouchBar : NSTouchBar
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options battlegroundsCardOptionsTouchBarDelegate:(id<BattlegroundsCardOptionsTouchBarDelegate>)battlegroundsCardOptionsTouchBarDelegate;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
@end

NS_ASSUME_NONNULL_END
