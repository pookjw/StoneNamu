//
//  HSDeckRepository.h
//  HSDeckRepository
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <Foundation/Foundation.h>
#import "HSDeck.h"
#import "BlizzardAPIRegionHost.h"
#import "HSCardHero.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HSDeckRepository <NSObject>

typedef void (^HSDeckRepositoryFetchDeckFromCardIdsCompletion)(HSDeck * _Nullable, NSError * _Nullable);

- (void)fetchDeckAtRegion:(BlizzardAPIRegionHost)regionHost
              withOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options
               completion:(HSDeckRepositoryFetchDeckFromCardIdsCompletion)completion;

@end

NS_ASSUME_NONNULL_END
