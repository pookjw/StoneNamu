//
//  HSCardUseCase.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <Foundation/Foundation.h>
#import "HSCard.h"

typedef void (^HSCardUseCaseCardsCompletion)(NSArray<HSCard *> * _Nullable, NSError * _Nullable);
typedef void (^HSCardUseCaseCardCompletion)(HSCard * _Nullable, NSError * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@protocol HSCardUseCase <NSObject>

- (void)fetchWithOptions:(NSDictionary<NSString *, id> * _Nullable)options
         completionHandler:(HSCardUseCaseCardsCompletion)completion;

- (void)fetchWithIdOrSlug:(NSString *)idOrSlug
               withOptions:(NSDictionary<NSString *, id> * _Nullable)options
         completionHandler:(HSCardUseCaseCardCompletion)completion;

@end

NS_ASSUME_NONNULL_END
