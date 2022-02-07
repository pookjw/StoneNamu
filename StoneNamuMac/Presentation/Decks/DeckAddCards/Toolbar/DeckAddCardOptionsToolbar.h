//
//  DeckAddCardOptionsToolbar.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import <Cocoa/Cocoa.h>
#import "DeckAddCardOptionsToolbarDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionsToolbar = @"NSToolbarIdentifierDeckAddCardOptionsToolbar";

@interface DeckAddCardOptionsToolbar : NSToolbar
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier options:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options deckAddCardOptionsToolbarDelegate:(id<DeckAddCardOptionsToolbarDelegate>)deckAddCardOptionsToolbarDelegate;
- (void)updateWithSlugsAndNames:(NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *)slugsAndNames slugsAndIds:(NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *)slugsAndIds;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
@end

NS_ASSUME_NONNULL_END
