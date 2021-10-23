//
//  HSCardRepositoryImpl.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/HSCardRepository.h>
#else
#import <StoneNamuCore/HSCardRepository.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface HSCardRepositoryImpl : NSObject <HSCardRepository>

@end

NS_ASSUME_NONNULL_END
