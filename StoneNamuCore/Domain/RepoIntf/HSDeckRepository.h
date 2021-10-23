//
//  HSDeckRepository.h
//  HSDeckRepository
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/HSDeck.h>
#import <StoneNamuMacCore/BlizzardAPIRegionHost.h>

#else
#import <StoneNamuCore/HSDeck.h>
#import <StoneNamuCore/BlizzardAPIRegionHost.h>

#endif

NS_ASSUME_NONNULL_BEGIN

@protocol HSDeckRepository <NSObject>

typedef void (^HSDeckRepositoryFetchDeckCompletion)(HSDeck * _Nullable, NSError * _Nullable);

- (void)fetchDeckAtRegion:(BlizzardAPIRegionHost)regionHost
              withOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options
               completion:(HSDeckRepositoryFetchDeckCompletion)completion;

@end

NS_ASSUME_NONNULL_END
