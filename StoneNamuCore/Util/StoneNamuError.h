//
//  StoneNamuError.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * StoneNamuErrorType NS_STRING_ENUM;

static StoneNamuErrorType const StoneNamuErrorTypeInvalidHSCard = @"INVALID_HSCARD";
static StoneNamuErrorType const StoneNamuErrorTypeInvalidHSDeck = @"INVALID_HSDECK";
static StoneNamuErrorType const StoneNamuErrorTypeCannotAddNoMoreThanThirtyCards = @"DECK_ADD_CARD_ERROR_NO_MORE_THAN_THIRTY_CARDS";
static StoneNamuErrorType const StoneNamuErrorTypeCannotAddDifferentClassCard = @"DECK_ADD_CARD_ERROR_CANNOT_ADD_DIFFERENT_CLASS_CARD";
static StoneNamuErrorType const StoneNamuErrorTypeCannotAddNotCollectibleCard = @"DECK_ADD_CARD_ERROR_CANNOT_ADD_NOT_COLLECTIBLE_CARD";
static StoneNamuErrorType const StoneNamuErrorTypeCannotAddHeroPortraitCard = @"DECK_ADD_CARD_ERROR_CANNOT_ADD_HERO_PORTRAIT_CARD";
static StoneNamuErrorType const StoneNamuErrorTypeCannotAddSingleLegendaryCardMoreThanOne = @"DECK_ADD_CARD_ERROR_CANNOT_ADD_SINGLE_LAGENDARY_CARD_MORE_THAN_ONE";
static StoneNamuErrorType const StoneNamuErrorTypeCannotAddSingleCardMoreThanTwo = @"DECK_ADD_CARD_ERROR_CANNOT_ADD_SINGLE_CARD_MORE_THAN_TWO";
static StoneNamuErrorType const StoneNamuErrorTypeServerError = @"SERVER_ERROR";

@interface StoneNamuError : NSError
@property (copy, readonly) StoneNamuErrorType type;
- (instancetype)initWithErrorType:(StoneNamuErrorType)type;
+ (instancetype)errorWithErrorType:(StoneNamuErrorType)type;
@end

NS_ASSUME_NONNULL_END
