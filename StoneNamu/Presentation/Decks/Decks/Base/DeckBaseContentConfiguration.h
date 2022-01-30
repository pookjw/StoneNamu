//
//  DeckBaseContentConfiguration.h
//  DeckBaseContentConfiguration
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckBaseContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, retain) LocalDeck *localDeck;
@property (readonly) BOOL isEasterEgg;
@property (readonly) BOOL isDarkMode;
@property (readonly) NSUInteger count;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck isEasterEgg:(BOOL)isEasterEgg count:(NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
