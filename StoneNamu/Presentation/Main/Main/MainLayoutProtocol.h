//
//  MainLayoutProtocol.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 10/22/21.
//

#import <UIKit/UIKit.h>
#import "CardsViewController.h"
#import "DecksViewController.h"
#import "PrefsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MainLayoutProtocol <NSObject>
@property (retain) CardsViewController *cardsViewController;
@property (retain) CardsViewController *battlegroundsCardsViewController;
@property (retain) DecksViewController *decksViewController;
@property (retain) PrefsViewController *prefsViewController;
@property (readonly, nonatomic) NSArray<__kindof UIViewController *> *currentViewControllers;
- (void)activate;
- (void)deactivate;
- (void)restoreViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers;
@end

NS_ASSUME_NONNULL_END
