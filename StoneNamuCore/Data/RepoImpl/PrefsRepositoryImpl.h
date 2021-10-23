//
//  PrefsRepositoryImpl.h
//  PrefsRepositoryImpl
//
//  Created by Jinwoo Kim on 8/14/21.
//

#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/PrefsRepository.h>
#else
#import <StoneNamuCore/PrefsRepository.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface PrefsRepositoryImpl : NSObject <PrefsRepository>

@end

NS_ASSUME_NONNULL_END
