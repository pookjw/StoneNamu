//
//  BattlegroundsCardOptionsMenu.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import "BaseMenu.h"
#import "BattlegroundsCardOptionsMenuDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface BattlegroundsCardOptionsMenu : BaseMenu
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options battlegroundsCardOptionsMenuDelegate:(id<BattlegroundsCardOptionsMenuDelegate>)battlegroundsCardOptionsMenuDelegate;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
@end

NS_ASSUME_NONNULL_END
