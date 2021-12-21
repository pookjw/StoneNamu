//
//  HSCardSaveImageService.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/22/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSCardSaveImageService : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCards:(NSSet<HSCard *> *)hsCards;
- (void)beginSheetModalForWindow:(NSWindow * _Nullable)window
               completionHandler:(void (^)(NSModalResponse result))handler;
@end

NS_ASSUME_NONNULL_END
