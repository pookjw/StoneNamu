//
//  DeckDetailsManaCostGraphView.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/16/21.
//

#import <Cocoa/Cocoa.h>
#import "DeckDetailsManaCostGraph.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsManaCostGraphView : NSView
- (void)configureWithDatas:(NSArray<DeckDetailsManaCostGraph *> *)datas;
@end

NS_ASSUME_NONNULL_END
