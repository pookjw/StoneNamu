//
//  NSImage+dataUsingType.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/23/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (dataUsingType)
- (NSData *)dataUsingType:(NSBitmapImageFileType)storageType;
- (NSData * _Nullable)dataUsingUniformType:(UTType *)uniformType;
@end

NS_ASSUME_NONNULL_END
