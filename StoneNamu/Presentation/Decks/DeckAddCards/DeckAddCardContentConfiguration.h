//
//  DeckAddCardContentConfiguration.h
//  DeckAddCardContentConfiguration
//
//  Created by Jinwoo Kim on 8/1/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) HSCard *hsCard;
@property (readonly) NSUInteger count;
@property (readonly) BOOL isLegendary;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCard:(HSCard *)hsCard count:(NSUInteger)count isLegendary:(BOOL)isLegendary;
@end

NS_ASSUME_NONNULL_END
