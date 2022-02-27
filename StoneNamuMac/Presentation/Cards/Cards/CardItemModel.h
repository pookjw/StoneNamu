//
//  CardItemModel.h
//  CardItemModel
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardItemModel : NSObject
@property (readonly, copy) HSCard *hsCard;
@property (readonly, copy) HSCardTypeSlugType hsCardGameModeSlugType;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCard:(HSCard *)hsCard hsCardGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType;
@end

NS_ASSUME_NONNULL_END
