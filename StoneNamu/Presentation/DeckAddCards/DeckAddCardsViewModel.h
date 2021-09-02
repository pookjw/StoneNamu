//
//  DeckAddCardsViewModel.h
//  DeckAddCardsViewModel
//
//  Created by Jinwoo Kim on 9/2/21.
//

#import <Foundation/Foundation.h>
#import "LocalDeck.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const DeckAddCardsViewModelErrorOccurredNotificationKey = @"DeckAddCardsViewModelErrorOccurredNotificationKey";
static NSString * const DeckAddCardsViewModelErrorOccurredErrorItemKey = @"DeckAddCardsViewModelErrorOccurredErrorItemKey";

@interface DeckAddCardsViewModel : NSObject
@property (retain) LocalDeck * _Nullable localDeck;
- (void)addHSCards:(NSArray<HSCard *> *)hsCards;
- (NSDictionary<NSString *, NSString *> * _Nullable)optionsForLocalDeckClassId;
@end

NS_ASSUME_NONNULL_END
