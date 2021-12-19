//
//  DeckDetailsManaCostGraphBaseView.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/19/21.
//

#import <Cocoa/Cocoa.h>
#import "DeckDetailsManaCostGraphData.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsManaCostGraphBaseView : NSView
- (void)configureWithData:(DeckDetailsManaCostGraphData *)data;
@end

NS_ASSUME_NONNULL_END
