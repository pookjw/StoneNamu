//
//  CardOptionsMenuDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CardOptionsMenu;

@protocol CardOptionsMenuDelegate <NSObject>
- (void)cardOptionsMenu:(CardOptionsMenu *)menu changedOption:(NSDictionary<NSString *, NSSet<NSString *> *> *)options;
- (void)cardOptionsMenu:(CardOptionsMenu *)menu defaultOptionsAreNeedWithSender:(NSMenuItem *)sender;
@end

NS_ASSUME_NONNULL_END
