//
//  DeckDetailsViewController.h
//  DeckDetailsViewController
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <UIKit/UIKit.h>
#import "LocalDeck.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsViewController : UIViewController
- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
