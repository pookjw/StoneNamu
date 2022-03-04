//
//  HSCardUseCase.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSCard.h>
#import <StoneNamuCore/HSCardGameMode.h>

typedef void (^HSCardUseCaseCardsCompletion)(NSArray<HSCard *> * _Nullable hsCards, NSNumber * _Nullable pageCount, NSNumber * _Nullable page, NSError * _Nullable error);
typedef void (^HSCardUseCaseCardCompletion)(HSCard * _Nullable hsCard, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@protocol HSCardUseCase <NSObject>
- (void)fetchWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options
       completionHandler:(HSCardUseCaseCardsCompletion)completion;
- (void)fetchWithIdOrSlug:(NSString *)idOrSlug
              withOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options
        completionHandler:(HSCardUseCaseCardCompletion)completion;
- (NSURL * _Nullable)preferredImageURLOfHSCard:(HSCard *)hsCard HSCardGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold;
@end

NS_ASSUME_NONNULL_END
