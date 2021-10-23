//
//  HSDeckUseCaseImpl.h
//  HSDeckUseCaseImpl
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/HSDeckUseCase.h>
#else
#import <StoneNamuCore/HSDeckUseCase.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface HSDeckUseCaseImpl : NSObject <HSDeckUseCase>

@end

NS_ASSUME_NONNULL_END
