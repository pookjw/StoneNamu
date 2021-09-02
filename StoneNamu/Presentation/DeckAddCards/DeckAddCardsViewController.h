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

@interface DeckAddCardsViewController : UIViewController <DeckAddCardOptionsViewControllerDelegate>
- (NSDictionary<NSString *, NSString *> * _Nullable)setOptionsBarButtonItemHidden:(BOOL)hidden;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
