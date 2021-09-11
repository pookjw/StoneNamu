//
//  DeckImageRenderService.h
//  DeckImageRenderService
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import <UIKit/UIKit.h>
#import "LocalDeck.h"
#import "HSDeck.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^DeckImageRenderServiceCompletion)(UIImage *);

@interface DeckImageRenderService : NSObject
- (void)imageFromLocalDeck:(LocalDeck *)localDeck completion:(DeckImageRenderServiceCompletion)completion testVC:(UIViewController *)testVC;
- (void)imageFromHSDeck:(HSDeck *)hsDeck completion:(DeckImageRenderServiceCompletion)completion;
@end

NS_ASSUME_NONNULL_END
