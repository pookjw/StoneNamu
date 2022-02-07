//
//  DecksMenu.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/27/21.
//

#import <Cocoa/Cocoa.h>
#import "BaseMenu.h"
#import "DecksMenuDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DecksMenu : BaseMenu
@property (retain, readonly) NSMenuItem *editDeckNameItem;
@property (retain, readonly) NSMenuItem *deleteItem;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDecksMenuDelegate:(id<DecksMenuDelegate>)decksMenuDelegate;
- (void)updateWithSlugsAndNames:(NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSString *> *> *)slugsAndNames slugsAndIds:(NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSNumber *> *> *)slugsAndIds;
@end

NS_ASSUME_NONNULL_END
