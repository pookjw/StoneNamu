//
//  NSIndexPath+identifier.h
//  NSIndexPath+identifier
//
//  Created by Jinwoo Kim on 8/29/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSIndexPath (identifier)
@property (readonly, nonatomic) NSString *identifier;
+ (instancetype)indexPathFromString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
