//
//  DeckDetailsManaCostGraphView.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/16/21.
//

#import <Cocoa/Cocoa.h>
#import "DeckDetailsManaCostGraphData.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsManaCostGraphView : NSView
- (void)configureWithDatas:(NSArray<DeckDetailsManaCostGraphData *> *)datas;
@end

NS_ASSUME_NONNULL_END
