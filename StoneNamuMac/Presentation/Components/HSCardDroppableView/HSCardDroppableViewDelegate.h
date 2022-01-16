//
//  HSCardDroppableViewDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 1/17/22.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

@class HSCardDroppableView;

NS_ASSUME_NONNULL_BEGIN

@protocol HSCardDroppableViewDelegate <NSObject>
- (void)hsCardDroppableView:(HSCardDroppableView *)view didAcceptDropWithHSCards:(NSArray<HSCard *> *)hsCards;
@end

NS_ASSUME_NONNULL_END
