//
//  HSCardSaveImageService.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/22/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HSCardSaveImageServiceSheetCompletion)(BOOL success, NSError * _Nullable error);

@interface HSCardSaveImageService : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCards:(NSSet<HSCard *> *)hsCards;
- (void)beginSheetModalForWindow:(NSWindow * _Nullable)window completion:(HSCardSaveImageServiceSheetCompletion)completion;
@end

NS_ASSUME_NONNULL_END
