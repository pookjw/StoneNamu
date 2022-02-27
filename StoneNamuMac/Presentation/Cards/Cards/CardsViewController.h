//
//  CardsViewController.h
//  CardsViewController
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardsViewController : NSViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType;
@end

NS_ASSUME_NONNULL_END
