//
//  DeckImageRenderService.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/25/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DeckImageRenderServiceCompletion)(NSImage *);

@interface DeckImageRenderService : NSObject
- (void)imageFromLocalDeck:(LocalDeck *)localDeck completion:(DeckImageRenderServiceCompletion)completion;
@end

NS_ASSUME_NONNULL_END
