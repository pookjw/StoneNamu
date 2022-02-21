//
//  DeckAddCardOptionsMenu.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "BaseMenu.h"
#import "DeckAddCardOptionsMenuDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardOptionsMenu : BaseMenu
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options localDeck:(LocalDeck * _Nullable)localDeck deckAddCardOptionsMenuDelegate:(id<DeckAddCardOptionsMenuDelegate>)deckAddCardOptionsMenuDelegate;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
- (void)setLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
