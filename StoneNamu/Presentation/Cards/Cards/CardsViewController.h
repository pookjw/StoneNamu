//
//  CardsViewController.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/23/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "CardOptionsViewControllerDelegate.h"
#import "BattlegroundsCardOptionsViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardsViewController : UIViewController <CardOptionsViewControllerDelegate, BattlegroundsCardOptionsViewControllerDelegate>
@property (readonly, copy) NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable options;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType;
- (void)requestWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
- (void)setOptionsBarButtonItemHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
