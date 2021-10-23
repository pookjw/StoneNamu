//
//  DeckBaseContentViewModel.h
//  DeckBaseContentViewModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckBaseContentViewModel : NSObject
- (UIImage * _Nullable)portraitImageOfLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
