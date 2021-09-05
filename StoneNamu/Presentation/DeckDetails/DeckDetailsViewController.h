//
//  DeckDetailsViewController.h
//  DeckDetailsViewController
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <UIKit/UIKit.h>
#import "LocalDeck.h"
#import "HSCard.h"
#import "DeckDetailsViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckDetailsViewControllerRightBarButtonType) {
    DeckDetailsViewControllerRightBarButtonTypeMenu = 1 << 0,
    DeckDetailsViewControllerRightBarButtonTypeDone = 1 << 1
};

@interface DeckDetailsViewController : UIViewController
@property (weak) id<DeckDetailsViewControllerDelegate> delegate;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck presentEditorIfNoCards:(BOOL)shouldPresentDeckEditor;
- (void)setRightBarButtons:(DeckDetailsViewControllerRightBarButtonType)type;
- (void)addHSCardsToLocalDeck:(NSArray<HSCard *> *)hsCards;
@end

NS_ASSUME_NONNULL_END
