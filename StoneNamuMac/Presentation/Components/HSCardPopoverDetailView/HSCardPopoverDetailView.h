//
//  HSCardPopoverDetailView.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/29/22.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSCardPopoverDetailView : NSView
@property (readonly, nonatomic) BOOL isShown;
- (void)setHSCard:(HSCard * _Nullable)hsCard hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold;
@end

NS_ASSUME_NONNULL_END
