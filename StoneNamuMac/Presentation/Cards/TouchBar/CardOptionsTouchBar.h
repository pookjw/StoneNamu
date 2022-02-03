//
//  CardOptionsTouchBar.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import <Cocoa/Cocoa.h>
#import "CardOptionsTouchBarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardOptionsTouchBar : NSTouchBar
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options cardOptionsTouchBarDelegate:(id<CardOptionsTouchBarDelegate>)cardOptionsTouchBarDelegate;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
@end

NS_ASSUME_NONNULL_END
