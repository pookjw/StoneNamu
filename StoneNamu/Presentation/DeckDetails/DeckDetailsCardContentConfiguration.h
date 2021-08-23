//
//  DeckDetailsCardContentConfiguration.h
//  DeckDetailsCardContentConfiguration
//
//  Created by Jinwoo Kim on 8/23/21.
//

#import <UIKit/UIKit.h>
#import "HSCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsCardContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) HSCard *hsCard;
- (instancetype)initWithHSCard:(HSCard *)hsCard count:(NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
