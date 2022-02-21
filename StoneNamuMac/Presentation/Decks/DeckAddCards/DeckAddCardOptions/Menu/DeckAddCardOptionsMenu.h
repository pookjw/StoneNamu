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
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options deckAddCardOptionsMenuDelegate:(id<DeckAddCardOptionsMenuDelegate>)deckAddCardOptionsMenuDelegate;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
@end

NS_ASSUME_NONNULL_END
