//
//  DeckAddCardItemModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>
#import "HSCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardItemModel : NSObject
@property (readonly, copy) HSCard *card;
@property NSUInteger count;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCard:(HSCard *)card count:(NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
