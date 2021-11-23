//
//  HSCard+Pasteboard.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/23/21.
//

#import <StoneNamuCore/StoneNamuCore.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSCard (Pasteboard) <NSPasteboardWriting, NSPasteboardReading>

@end

NS_ASSUME_NONNULL_END
