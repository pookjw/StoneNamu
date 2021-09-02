//
//  StoneNamuCoreErrors.h
//  StoneNamuCoreErrors
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import <Foundation/Foundation.h>

NSError * DataCorruptionError(void);

NSError * InvalidHSCardError(void);

NSError * InvalidHSDeckError(void);

NSError * CannotAddNoMoreThanThirtyCardsError(void);

NSError * CannotAddDifferentClassCardError(void);

NSError * CannotAddNotCollectibleCardError(void);

NSError * CannotAddHeroPortraitCardError(void);

NSError * CannotAddSingleLegendaryCardMoreThanOneError(void);

NSError * CannotAddSingleCardMoreThanTwoError(void);
