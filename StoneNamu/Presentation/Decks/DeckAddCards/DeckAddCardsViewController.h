//
//  DeckAddCardsViewController.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/23/21.
//

#import <UIKit/UIKit.h>
#import "DeckAddCardOptionsViewControllerDelegate.h"
#import "LocalDeck.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckAddCardsViewControllerRightBarButtonType) {
    DeckAddCardsViewControllerRightBarButtonTypeDone = 1 << 0
};

@interface DeckAddCardsViewController : UIViewController <DeckAddCardOptionsViewControllerDelegate>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck;
- (void)setDeckDetailsButtonHidden:(BOOL)hidden;
- (LocalDeck *)localDeck;
- (void)setRightBarButtons:(DeckAddCardsViewControllerRightBarButtonType)type;
- (void)requestDismissWithPromptIfNeeded;
@end

NS_ASSUME_NONNULL_END
