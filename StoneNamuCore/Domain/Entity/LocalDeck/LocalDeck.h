//
//  LocalDeck.h
//  LocalDeck
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <CoreData/CoreData.h>
#import <StoneNamuCore/HSDeck.h>
#import <StoneNamuCore/HSCard.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalDeck : NSManagedObject
@property (assign) NSData * _Nullable hsCardsData;
@property (assign) NSString * _Nullable format;
@property (assign) NSNumber * _Nullable classId;
@property (assign) NSString * _Nullable deckCode;
@property (assign) NSString * _Nullable name;
@property (assign) NSDate * _Nullable timestamp;

@property (assign, nonatomic) NSArray<HSCard *> *hsCards;
@property (readonly, nonatomic) NSArray<NSNumber *> *hsCardIds;

- (void)setValuesAsHSDeck:(HSDeck *)hsDeck;
- (void)updateTimestamp;
@end

NS_ASSUME_NONNULL_END
