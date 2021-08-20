//
//  HSDeckUseCase.h
//  HSDeckUseCase
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import <Foundation/Foundation.h>
#import "HSDeck.h"
#import "HSCardHero.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HSDeckUseCase <NSObject>

typedef void (^HSDeckUseCaseFetchDeckByDeckCodeCompletion)(HSDeck * _Nullable, NSError * _Nullable);
typedef void (^HSDeckUseCaseFetchDeckByCardListCompletion)(HSDeck * _Nullable, NSError * _Nullable);

- (void)fetchDeckByDeckCode:(NSString *)deckCode
                 completion:(HSDeckUseCaseFetchDeckByDeckCodeCompletion)completion;
- (void)fetchDeckByCardList:(NSArray<NSNumber *> *)cardList
                 completion:(HSDeckUseCaseFetchDeckByCardListCompletion)completion;

@end

NS_ASSUME_NONNULL_END