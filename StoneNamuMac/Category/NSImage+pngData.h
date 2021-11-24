//
//  NSImage+pngData.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/24/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (pngData)
@property (readonly, nonatomic) NSData *pngData;
@end

NS_ASSUME_NONNULL_END
