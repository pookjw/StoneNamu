//
//  DeckAddCardsViewController.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardsViewController : NSViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
