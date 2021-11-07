//
//  SpinnerView.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/26/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpinnerView : NSView
- (void)startAnimating;
- (void)stopAnimating;
@end

NS_ASSUME_NONNULL_END
