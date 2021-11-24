//
//  HSCardDraggableImageView.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSCardDraggableImageView : NSImageView
- (instancetype)initWithHSCard:(HSCard *)hsCard;
@end

NS_ASSUME_NONNULL_END
