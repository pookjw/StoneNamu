//
//  CardDetailsChildrenContentItemModel.h
//  CardDetailsChildrenContentItemModel
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import <Foundation/Foundation.h>
#import "HSCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsChildrenContentItemModel : NSObject
@property (readonly, copy) HSCard *hsCard;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCard:(HSCard *)hsCard;
@end

NS_ASSUME_NONNULL_END
