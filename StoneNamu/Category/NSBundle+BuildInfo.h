//
//  NSBundle+BuildInfo.h
//  NSBundle+BuildInfo
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (BuildInfo)
@property (readonly, nonatomic) NSString * _Nullable releaseVersionString;
@property (readonly, nonatomic) NSString * _Nullable buildVersionString;
@end

NS_ASSUME_NONNULL_END
