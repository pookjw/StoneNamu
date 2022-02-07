//
//  DecksToolbar.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import <Cocoa/Cocoa.h>
#import "DecksToolbarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

static NSToolbarIdentifier const NSToolbarIdentifierDecksToolbar = @"NSToolbarIdentifierDecksToolbar";

@interface DecksToolbar : NSToolbar
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier decksToolbarDelegate:(id<DecksToolbarDelegate>)decksToolbarDelegate;
- (void)updateWithSlugsAndNames:(NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSString *> *> *)slugsAndNames slugsAndIds:(NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSNumber *> *> *)slugsAndIds;
@end

NS_ASSUME_NONNULL_END
