//
//  DeckAddCardOptionsViewController.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>
#import "DeckAddCardOptionsViewControllerDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardOptionsViewController : UIViewController
@property (weak) id<DeckAddCardOptionsViewControllerDelegate> delegate;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options localDeck:(LocalDeck *)localDeck;
- (void)setCancelButtonHidden:(BOOL)hidden;
@end
NS_ASSUME_NONNULL_END
