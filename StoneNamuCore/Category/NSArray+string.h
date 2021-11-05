//
//  NSArray+string.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 10/27/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (string)
- (BOOL)containsString:(NSString *)string;
- (NSUInteger)indexOfString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
