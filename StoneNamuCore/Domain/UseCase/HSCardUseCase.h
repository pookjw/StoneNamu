//
//  HSCardUseCase.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSCard.h>
#import <StoneNamuCore/HSCardGameMode.h>

typedef void (^HSCardUseCaseCardsCompletion)(NSArray<HSCard *> * _Nullable, NSNumber * _Nullable, NSNumber * _Nullable, NSError * _Nullable);
typedef void (^HSCardUseCaseCardCompletion)(HSCard * _Nullable, NSError * _Nullable);
typedef void (^HSCardUseCaseAnimatedImageURLOfHSCardCompletion)(NSURL * _Nullable, NSError * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@protocol HSCardUseCase <NSObject>
- (void)fetchWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options
       completionHandler:(HSCardUseCaseCardsCompletion)completion;
- (void)fetchWithIdOrSlug:(NSString *)idOrSlug
              withOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options
        completionHandler:(HSCardUseCaseCardCompletion)completion;
- (NSURL * _Nullable)recommendedImageURLOfHSCard:(HSCard *)hsCard HSCardGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold;
- (void)animatedImageURLOfHSCard:(HSCard *)hsCard completionHandler:(HSCardUseCaseAnimatedImageURLOfHSCardCompletion)completion;
@end

NS_ASSUME_NONNULL_END
