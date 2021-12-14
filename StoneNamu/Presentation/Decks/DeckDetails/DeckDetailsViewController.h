//
//  DeckDetailsViewController.h
//  DeckDetailsViewController
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "DeckDetailsViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckDetailsViewControllerRightBarButtonType) {
    DeckDetailsViewControllerRightBarButtonTypeMenu = 1 << 0,
    DeckDetailsViewControllerRightBarButtonTypeDone = 1 << 1
};

@interface DeckDetailsViewController : UIViewController
@property (assign) id<DeckDetailsViewControllerDelegate> delegate;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck presentEditorIfNoCards:(BOOL)shouldPresentDeckEditor;
- (void)setRightBarButtons:(DeckDetailsViewControllerRightBarButtonType)type;
@end

NS_ASSUME_NONNULL_END
