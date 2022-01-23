//
//  NSScrubber+Private.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/4/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSScrubber (Private)
- (void)_interactiveSelectItemAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
- (void)scrollItemAtIndex:(NSInteger)index toAlignment:(NSScrubberAlignment)alignment animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
