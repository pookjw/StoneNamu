//
//  DeckDetailsViewController.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsViewController : NSViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck;

- (void)saveAsImageItemTriggered:(NSMenuItem *)sender;
- (void)exportDeckCodeItemTriggered:(NSMenuItem *)sender;
- (void)editDeckNameItemTriggered:(NSMenuItem *)sender;
- (void)deleteItemTriggered:(NSMenuItem *)sender;
@end

NS_ASSUME_NONNULL_END
