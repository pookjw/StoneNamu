//
//  DeckBaseContentConfiguration.h
//  DeckBaseContentConfiguration
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import <UIKit/UIKit.h>
#import "LocalDeck.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckBaseContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, retain) LocalDeck *localDeck;
@property (readonly) BOOL isDarkMode;
- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
