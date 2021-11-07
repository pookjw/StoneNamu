//
//  ViewMenuItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewMenuItem : NSMenuItem
- (instancetype)initWithTitle:(NSString *)string action:(nullable SEL)selector keyEquivalent:(NSString *)charCode NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
