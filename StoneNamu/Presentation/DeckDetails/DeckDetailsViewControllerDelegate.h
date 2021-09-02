//
//  DeckDetailsViewControllerDelegate.h
//  DeckDetailsViewControllerDelegate
//
//  Created by Jinwoo Kim on 9/1/21.
//

#import <UIKit/UIKit.h>

@class DeckDetailsViewController;

@protocol DeckDetailsViewControllerDelegate <NSObject>
- (BOOL)deckDetailsViewController:(DeckDetailsViewController *)viewController shouldPresentErrorAlertWithError:(NSError *)error;
@end
