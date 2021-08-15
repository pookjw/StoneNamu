//
//  NSBundle+buildInfo.m
//  NSBundle+buildInfo
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "NSBundle+BuildInfo.h"

@implementation NSBundle (BuildInfo)

- (NSString * _Nullable)releaseVersionString {
    return self.infoDictionary[@"CFBundleShortVersionString"];
}

- (NSString * _Nullable)buildVersionString {
    return self.infoDictionary[@"CFBundleVersion"];
}

@end
