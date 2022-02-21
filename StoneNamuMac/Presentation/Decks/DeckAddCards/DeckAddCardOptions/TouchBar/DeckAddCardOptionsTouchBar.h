//
//  DeckAddCardOptionsTouchBar.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import <Cocoa/Cocoa.h>
#import "DeckAddCardOptionsTouchBarDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardOptionsTouchBar : NSTouchBar
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options localDeck:(LocalDeck * _Nullable)localDeck deckAddCardOptionsTouchBarDelegate:(id<DeckAddCardOptionsTouchBarDelegate>)deckAddCardOptionsTouchBarDelegate;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
- (void)setLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
