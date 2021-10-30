//
//  KeyMenuItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/31/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyMenuItem : NSMenuItem
@property (readonly, copy) NSDictionary * _Nullable key;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTitle:(NSString *)string action:(nullable SEL)selector keyEquivalent:(NSString *)charCode NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithTitle:(NSString *)string action:(nullable SEL)selector keyEquivalent:(NSString *)charCode key:(NSDictionary * _Nullable)key;
@end

NS_ASSUME_NONNULL_END
