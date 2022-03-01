//
//  CardDetailsViewController.h
//  CardDetailsViewController
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsViewController : UIViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCard:(HSCard * _Nullable)hsCard hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold sourceImageView:(UIImageView * _Nullable)sourceImageView;
- (void)requestHSCard:(HSCard *)hsCard;
@end

NS_ASSUME_NONNULL_END
