//
//  DeckDetailsCardContentConfiguration.h
//  DeckDetailsCardContentConfiguration
//
//  Created by Jinwoo Kim on 8/23/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsCardContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) HSCard *hsCard;
@property (readonly) NSUInteger hsCardCount;
@property (readonly) BOOL isDarkMode;
@property (readonly, copy) HSCardRaritySlugType raritySlugType;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCard:(HSCard *)hsCard hsCardCount:(NSUInteger)hsCardCount raritySlugType:(HSCardRaritySlugType)raritySlugType;
@end

NS_ASSUME_NONNULL_END
