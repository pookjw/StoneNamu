//
//  ActivityIndicatorService.h
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityIndicatorService : NSObject
- (void)showActivityIndicatorViewOnView:(id)view superviewIfNeeded:(BOOL)superviewIfNeeded;
- (void)removeActivityIndicatorViewFromView:(id)view superviewIfNeeded:(BOOL)superviewIfNeeded;
@end

NS_ASSUME_NONNULL_END
