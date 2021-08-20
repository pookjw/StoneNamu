//
//  LocalDeck.h
//  LocalDeck
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <CoreData/CoreData.h>
#import "HSDeck.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalDeck : NSManagedObject
@property (assign) NSData * _Nullable cardsData;
@property (assign) NSNumber * _Nullable isWild;
@property (assign) NSNumber * _Nullable classId;
@property (assign) NSString * _Nullable deckCode;
@property (assign) NSString * _Nullable name;

@property (assign, nonatomic) NSArray<NSNumber *> *cards;

- (void)setValuesAsHSDeck:(HSDeck *)hsDeck;
@end

NS_ASSUME_NONNULL_END
