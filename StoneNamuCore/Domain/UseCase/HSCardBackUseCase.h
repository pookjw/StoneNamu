//
//  HSCardBackUseCase.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 3/5/22.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSCardBack.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HSCardBackUseCaseCardsCompletion)(NSArray<HSCardBack *> * _Nullable hsCardBacks, NSNumber * _Nullable pageCount, NSNumber * _Nullable page, NSError * _Nullable error);
typedef void (^HSCardBackUseCaseCardCompletion)(HSCardBack * _Nullable hsCardBack, NSError * _Nullable error);

@protocol HSCardBackUseCase <NSObject>
- (void)fetchWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options
       completionHandler:(HSCardBackUseCaseCardsCompletion)completion;
- (void)fetchWithIdOrSlug:(NSString *)idOrSlug
              withOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options
        completionHandler:(HSCardBackUseCaseCardCompletion)completion;
@end

NS_ASSUME_NONNULL_END
