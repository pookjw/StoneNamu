//
//  DeckAddCardOptionsToolbar.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import <Cocoa/Cocoa.h>
#import "DeckAddCardOptionsToolbarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionsToolbar = @"NSToolbarIdentifierDeckAddCardOptionsToolbar";

@interface DeckAddCardOptionsToolbar : NSToolbar
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier options:(NSDictionary<NSString *, NSString *> * _Nullable)options deckAddCardOptionsToolbarDelegate:(id<DeckAddCardOptionsToolbarDelegate>)deckAddCardOptionsToolbarDelegate;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options;
@end

NS_ASSUME_NONNULL_END
