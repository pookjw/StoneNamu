//
//  CardItemModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>
#import "HSCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardItemModel : NSObject
@property (readonly, copy) HSCard *hsCard;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCard:(HSCard *)hsCard;
@end

NS_ASSUME_NONNULL_END
