//
//  BattlegroundsCardOptionsToolbar.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import <Cocoa/Cocoa.h>
#import "BattlegroundsCardOptionsToolbarDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSToolbarIdentifier const NSToolbarIdentifierBattlegroundsCardOptionsToolbar = @"NSToolbarIdentifierBattlegroundsCardOptionsToolbar";

@interface BattlegroundsCardOptionsToolbar : NSToolbar
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier options:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options battlegroundsCardOptionsToolbarDelegate:(id<BattlegroundsCardOptionsToolbarDelegate>)battlegroundsCardOptionsToolbarDelegate;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
@end

NS_ASSUME_NONNULL_END
