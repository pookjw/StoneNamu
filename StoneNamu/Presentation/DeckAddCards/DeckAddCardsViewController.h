//
//  DeckAddCardsViewController.h
//  DeckAddCardsViewController
//
//  Created by Jinwoo Kim on 9/1/21.
//

#import "CardsViewController.h"
#import "LocalDeck.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardsViewController : CardsViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
