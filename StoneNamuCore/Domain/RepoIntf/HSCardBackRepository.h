//
//  HSCardBackRepository.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 3/5/22.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSCardBack.h>
#import <StoneNamuCore/BlizzardAPIRegionHost.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HSCardBackRepositoryFetchCardBacksCompletion)(NSArray<HSCardBack *> * _Nullable hsCardBacks, NSNumber * _Nullable pageCount, NSNumber * _Nullable page, NSError * _Nullable error);
typedef void (^HSCardBackRepositoryFetchCardBackCompletion)(HSCardBack * _Nullable hsCards, NSError * _Nullable error);

@protocol HSCardBackRepository <NSObject>

- (void)fetchCardsAtRegion:(BlizzardAPIRegionHost)regionHost
               withOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options
         completionHandler:(HSCardBackRepositoryFetchCardBacksCompletion)completion;

- (void)fetchCardAtRegion:(BlizzardAPIRegionHost)regionHost
              withIdOrSlug:(NSString *)idOrSlug
               withOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options
         completionHandler:(HSCardBackRepositoryFetchCardBackCompletion)completion;

@end

NS_ASSUME_NONNULL_END
