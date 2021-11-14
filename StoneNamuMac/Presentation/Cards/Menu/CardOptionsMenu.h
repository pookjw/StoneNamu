//
//  CardOptionsMenu.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import <Cocoa/Cocoa.h>
#import "BaseMenu.h"
#import "CardOptionsMenuDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardOptionsMenu : BaseMenu
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options cardOptionsMenuDelegate:(id<CardOptionsMenuDelegate>)cardOptionsMenuDelegate;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options;
@end

NS_ASSUME_NONNULL_END
