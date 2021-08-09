//
//  CardDetailsChildrenContentImageConfiguration.h
//  CardDetailsChildrenContentImageConfiguration
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import <UIKit/UIKit.h>
#import "HSCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsChildrenContentImageConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) HSCard *hsCard;
- (instancetype)initWithHSCard:(HSCard *)hsCard;
@end

NS_ASSUME_NONNULL_END
