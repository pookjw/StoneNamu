//
//  PrefsUseCaseImpl.h
//  PrefsUseCaseImpl
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/PrefsUseCase.h>
#else
#import <StoneNamuCore/PrefsUseCase.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface PrefsUseCaseImpl : NSObject <PrefsUseCase>

@end

NS_ASSUME_NONNULL_END
