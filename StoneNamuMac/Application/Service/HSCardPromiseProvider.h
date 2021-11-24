//
//  HSCardPromiseProvider.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/23/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSCardPromiseProvider : NSFilePromiseProvider
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFileType:(NSString *)fileType delegate:(id <NSFilePromiseProviderDelegate>)delegate NS_UNAVAILABLE;
- (instancetype)initWithHSCard:(HSCard *)hsCard image:(NSImage *)image;
@end

NS_ASSUME_NONNULL_END
