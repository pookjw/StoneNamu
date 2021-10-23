//
//  HSCardRepository.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSCard.h>
#import <StoneNamuCore/BlizzardAPIRegionHost.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HSCardRepositoryFetchCardsCompletion)(NSArray<HSCard *> * _Nullable, NSNumber * _Nullable, NSNumber * _Nullable, NSError * _Nullable);
typedef void (^HSCardRepositoryFetchCardCompletion)(HSCard * _Nullable, NSError * _Nullable);

@protocol HSCardRepository <NSObject>

- (void)fetchCardsAtRegion:(BlizzardAPIRegionHost)regionHost
               withOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options
         completionHandler:(HSCardRepositoryFetchCardsCompletion)completion;

- (void)fetchCardAtRegion:(BlizzardAPIRegionHost)regionHost
              withIdOrSlug:(NSString *)idOrSlug
               withOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options
         completionHandler:(HSCardRepositoryFetchCardCompletion)completion;

@end

NS_ASSUME_NONNULL_END
