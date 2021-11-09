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
- (void)cardOptionsMenu:(CardOptionsMenu *)menu changedOption:(NSDictionary<NSString *, NSString *> *)options;
@end

NS_ASSUME_NONNULL_END
