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
@property (copy) HSCard * _Nullable hsCard;
@property (readonly, nonatomic) BOOL isShown;
@end

NS_ASSUME_NONNULL_END
