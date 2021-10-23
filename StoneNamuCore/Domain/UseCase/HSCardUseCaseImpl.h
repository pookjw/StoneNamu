//
//  HSCardUseCaseImpl.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/HSCardUseCase.h>
#else
#import <StoneNamuCore/HSCardUseCase.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface HSCardUseCaseImpl : NSObject<HSCardUseCase>

@end

NS_ASSUME_NONNULL_END
