//
//  HSCardRepository.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <Foundation/Foundation.h>
#import "HSCard.h"
#import "BlizzardAPIRegionHost.h"

typedef void (^HSCardRepositoryCardsCompletion)(NSArray<HSCard *> * _Nullable, NSNumber * _Nullable, NSNumber * _Nullable, NSError * _Nullable);
typedef void (^HSCardRepositoryCardCompletion)(HSCard * _Nullable, NSError * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@protocol HSCardRepository <NSObject>

- (void)fetchCardsAtRegion:(BlizzardAPIRegionHost)regionHost
               withOptions:(NSDictionary<NSString *, id> * _Nullable)options
         completionHandler:(HSCardRepositoryCardsCompletion)completion;

- (void)fetchCardAtRegion:(BlizzardAPIRegionHost)regionHost
              withIdOrSlug:(NSString *)idOrSlug
               withOptions:(NSDictionary<NSString *, id> * _Nullable)options
         completionHandler:(HSCardRepositoryCardCompletion)completion;

@end

NS_ASSUME_NONNULL_END
