//
//  DeckAddCardSplitViewController.h
//  DeckAddCardSplitViewController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardSplitViewController : UISplitViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
