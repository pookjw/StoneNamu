//
//  DeckDetailsManaCostGraph.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/16/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsManaCostGraph : NSObject
@property (readonly) NSUInteger manaCost;
@property (readonly) float percentage;
@property (readonly) NSUInteger count;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithManaCost:(NSUInteger)manaCost percentage:(float)percentage count:(NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
