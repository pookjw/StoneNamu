//
//  DecksTouchBar.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import <Cocoa/Cocoa.h>
#import "DecksTouchBarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface DecksTouchBar : NSTouchBar
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithDecksTouchBarDelegate:(id<DecksTouchBarDelegate>)decksTouchBarDelegate;
- (void)updateWithSlugsAndNames:(NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSString *> *> *)slugsAndNames slugsAndIds:(NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSNumber *> *> *)slugsAndIds;
@end

NS_ASSUME_NONNULL_END
