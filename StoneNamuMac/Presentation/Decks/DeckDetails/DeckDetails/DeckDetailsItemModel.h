//
//  DeckDetailsItemModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsItemModel : NSObject
@property (readonly, copy) HSCard *hsCard;
@property (copy) NSNumber *hsCardCount;
@property (readonly, copy) HSCardRaritySlugType raritySlugType;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCard:(HSCard *)hsCard hsCardCount:(NSNumber *)hsCardCount raritySlugType:(HSCardRaritySlugType)raritySlugType;
@end

NS_ASSUME_NONNULL_END
