//
//  NSView+imageRendered.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/25/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (imageRendered)
@property (readonly, nonatomic) NSImage *imageRendered;
@end

NS_ASSUME_NONNULL_END
