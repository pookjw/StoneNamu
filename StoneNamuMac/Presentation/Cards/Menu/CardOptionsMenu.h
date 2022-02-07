//
//  CardOptionsMenu.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "BaseMenu.h"
#import "CardOptionsMenuDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardOptionsMenu : BaseMenu
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options cardOptionsMenuDelegate:(id<CardOptionsMenuDelegate>)cardOptionsMenuDelegate;
- (void)updateWithSlugsAndNames:(NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *)slugsAndNames slugsAndIds:(NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *)slugsAndIds;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
@end

NS_ASSUME_NONNULL_END
