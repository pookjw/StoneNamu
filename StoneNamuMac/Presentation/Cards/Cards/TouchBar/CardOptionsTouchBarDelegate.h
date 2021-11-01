//
//  CardOptionsTouchBarDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CardOptionsTouchBar;

@protocol CardOptionsTouchBarDelegate <NSObject>
- (void)cardOptionsTouchBar:(CardOptionsTouchBar *)touchBar changedOption:(NSDictionary<NSString *, NSString *> *)options;
@end

NS_ASSUME_NONNULL_END
