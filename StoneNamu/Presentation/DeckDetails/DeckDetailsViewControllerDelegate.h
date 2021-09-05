//
//  DeckDetailsViewControllerDelegate.h
//  DeckDetailsViewControllerDelegate
//
//  Created by Jinwoo Kim on 9/1/21.
//

#import <UIKit/UIKit.h>

@class DeckDetailsViewController;

@protocol DeckDetailsViewControllerDelegate <NSObject>

@optional
- (BOOL)deckDetailsViewController:(DeckDetailsViewController *)viewController shouldPresentErrorAlertWithError:(NSError *)error;

@optional
- (BOOL)deckDetailsViewControllerShouldDismissWithDoneBarButtonItem:(DeckDetailsViewController *)viewController;

@end
