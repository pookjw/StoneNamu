//
//  CardContentConfiguration.h
//  CardContentConfiguration
//
//  Created by Jinwoo Kim on 8/1/21.
//

#import <UIKit/UIKit.h>
#import "HSCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardContentConfiguration : NSObject <UIContentConfiguration>
@property (copy) HSCard *hsCard;
@end

NS_ASSUME_NONNULL_END
