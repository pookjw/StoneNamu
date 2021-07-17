//
//  BlizzardHSRepository.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <Foundation/Foundation.h>
#import "HSCard.h"
#import "BlizzardAPIRegionHost.h"

typedef void (^BlizzardHSRepositoryCardsCompletion)(NSArray<HSCard *> * _Nullable, NSError * _Nullable);
typedef void (^BlizzardHSRepositoryCardCompletion)(HSCard * _Nullable, NSError * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@protocol BlizzardHSRepository <NSObject>
- (void)fetchCardsAtRegion:(BlizzardAPIRegionHost)regionHost
               withOptions:(NSDictionary<NSString *, id> *)options
          completionHandler:(BlizzardHSRepositoryCardsCompletion)completion;
@end

NS_ASSUME_NONNULL_END
