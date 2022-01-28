//
//  DeckDetailsSplitViewController.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "DeckAddCardsViewController.h"
#import "DeckDetailsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsSplitViewController : NSSplitViewController
@property (retain, readonly) DeckAddCardsViewController *deckAddCardsViewController;
@property (retain, readonly) DeckDetailsViewController *deckDetailsViewController;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocalDeck:(LocalDeck * _Nullable)localDeck;
@end

NS_ASSUME_NONNULL_END
