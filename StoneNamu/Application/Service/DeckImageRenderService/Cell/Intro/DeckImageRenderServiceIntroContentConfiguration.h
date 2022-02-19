//
//  DeckImageRenderServiceIntroContentConfiguration.h
//  DeckImageRenderServiceIntroContentConfiguration
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckImageRenderServiceIntroContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) NSString *classSlug;
@property (readonly, copy) NSString *className;
@property (readonly, copy) NSString *deckName;
@property (readonly, copy) HSDeckFormat _Nullable deckFormat;
@property (readonly) BOOL isEasterEgg;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithClassSlug:(NSString *)classSlug className:(NSString *)className deckName:(NSString *)deckName deckFormat:(HSDeckFormat)deckFormat isEasterEgg:(BOOL)isEasterEgg;
@end

NS_ASSUME_NONNULL_END
