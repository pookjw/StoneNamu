//
//  NSView+viewOfClass.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/30/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (viewOfClass)

- (__kindof NSView * _Nullable)subviewOfClass:(Class)class;
- (__kindof NSView * _Nullable)superviewOfClass:(Class)class;

@end

NS_ASSUME_NONNULL_END
