//
//  CardOptionsToolbar.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/30/21.
//

#import <Cocoa/Cocoa.h>
#import "CardOptionsToolbarDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardOptionsToolbar : NSToolbar
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSString *> *)options cardOptionsToolbarDelegate:(id<CardOptionsToolbarDelegate>)cardOptionsToolbarDelegate;
- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSString *> *)options;
@end

NS_ASSUME_NONNULL_END
