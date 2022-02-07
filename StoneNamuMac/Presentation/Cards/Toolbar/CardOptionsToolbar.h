//
//  CardOptionsToolbar.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/30/21.
//

#import <Cocoa/Cocoa.h>
#import "CardOptionsToolbarDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsToolbar = @"NSToolbarIdentifierCardOptionsToolbar";

@interface CardOptionsToolbar : NSToolbar
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier options:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options cardOptionsToolbarDelegate:(id<CardOptionsToolbarDelegate>)cardOptionsToolbarDelegate;
- (void)updateWithSlugsAndNames:(NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> *)slugsAndNames slugsAndIds:(NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> *)slugsAndIds;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
@end

NS_ASSUME_NONNULL_END
