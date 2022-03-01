//
//  CardDetailsWindow.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsWindow : NSWindow
- (instancetype)initWithHSCard:(HSCard *)hsCard hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold;
@end

NS_ASSUME_NONNULL_END
