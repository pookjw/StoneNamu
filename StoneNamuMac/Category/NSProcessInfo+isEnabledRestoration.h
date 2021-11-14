//
//  NSProcessInfo+isEnabledRestoration.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/15/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSProcessInfo (isEnabledRestoration)
@property (readonly, nonatomic) BOOL isEnabledRestoration;
@end

NS_ASSUME_NONNULL_END
