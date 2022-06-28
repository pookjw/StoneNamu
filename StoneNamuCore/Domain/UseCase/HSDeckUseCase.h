//
//  HSDeckUseCase.h
//  HSDeckUseCase
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSDeck.h>
#import <StoneNamuCore/HSCard.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HSDeckUseCaseFetchDeckByDeckCodeCompletion)(HSDeck * _Nullable, NSError * _Nullable);
typedef void (^HSDeckUseCaseFetchDeckByCardListCompletion)(HSDeck * _Nullable, NSError * _Nullable);

@protocol HSDeckUseCase <NSObject>
- (NSDictionary<NSString *, NSString *> *)parseDeckCodeFromString:(NSString *)string;
- (void)fetchDeckByDeckCode:(NSString *)deckCode
                 completion:(HSDeckUseCaseFetchDeckByDeckCodeCompletion)completion;
- (void)fetchDeckByCardList:(NSArray<NSNumber *> *)cardList
                    classId:(NSNumber *)classId
                 completion:(HSDeckUseCaseFetchDeckByCardListCompletion)completion;
@end

NS_ASSUME_NONNULL_END
