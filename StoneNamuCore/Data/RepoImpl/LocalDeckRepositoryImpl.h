//
//  LocalDeckRepositoryImpl.h
//  LocalDeckRepositoryImpl
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/LocalDeckRepository.h>
#else
#import <StoneNamuCore/LocalDeckRepository.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface LocalDeckRepositoryImpl : NSObject <LocalDeckRepository>

@end

NS_ASSUME_NONNULL_END
