//
//  DeckAddCardItemModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/8/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardItemModel : NSObject
@property (readonly, copy) HSCard *hsCard;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCard:(HSCard *)hsCard;
@end

NS_ASSUME_NONNULL_END