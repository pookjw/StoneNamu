//
//  DecksMenu.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/27/21.
//

#import <Cocoa/Cocoa.h>
#import "BaseMenu.h"
#import "DecksMenuDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface DecksMenu : BaseMenu
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDecksMenuDelegate:(id<DecksMenuDelegate>)decksMenuDelegate;
@end

NS_ASSUME_NONNULL_END
