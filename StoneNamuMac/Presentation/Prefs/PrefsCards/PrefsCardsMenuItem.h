//
//  PrefsCardsMenuItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/15/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrefsCardsMenuItem : NSMenuItem
@property (copy, readonly) NSString * _Nullable key;
- (instancetype)initWithKey:(NSString * _Nullable)key;
@end

NS_ASSUME_NONNULL_END
