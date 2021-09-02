//
//  DeckAddCardContentConfiguration.h
//  DeckAddCardContentConfiguration
//
//  Created by Jinwoo Kim on 8/1/21.
//

#import <UIKit/UIKit.h>
#import "HSCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardContentConfiguration : NSObject <UIContentConfiguration>
@property (copy) HSCard *hsCard;
@end

NS_ASSUME_NONNULL_END
