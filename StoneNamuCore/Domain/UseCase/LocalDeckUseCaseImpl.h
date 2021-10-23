//
//  LocalDeckUseCaseImpl.h
//  LocalDeckUseCaseImpl
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/LocalDeckUseCase.h>
#else
#import <StoneNamuCore/LocalDeckUseCase.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface LocalDeckUseCaseImpl : NSObject <LocalDeckUseCase>

@end

NS_ASSUME_NONNULL_END
