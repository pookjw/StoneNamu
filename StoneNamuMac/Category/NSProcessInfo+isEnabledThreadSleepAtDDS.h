//
//  NSProcessInfo+isEnabledThreadSleepAtDDS.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSProcessInfo (isEnabledThreadSleepAtDDS)
@property (readonly, nonatomic) BOOL isEnabledThreadSleepAtDDS;
@end

NS_ASSUME_NONNULL_END
