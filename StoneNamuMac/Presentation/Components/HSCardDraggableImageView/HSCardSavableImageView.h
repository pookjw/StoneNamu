//
//  HSCardSavableImageView.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSCardSavableImageView : NSImageView
- (instancetype)initWithHSCard:(HSCard *)hsCard hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold;
- (void)requestWithHSCard:(HSCard *)hsCard hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold;
@end

NS_ASSUME_NONNULL_END
