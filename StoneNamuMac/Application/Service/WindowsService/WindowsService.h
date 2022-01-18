//
//  WindowsService.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/12/22.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindowsService : NSObject
@property (class, readonly, nonatomic) WindowsService *sharedInstance;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (void)startWindowsObserving;
- (void)presentNewMainWindow;
- (BOOL)presentNewMainWindowIfNeeded;
- (void)presentCardDetailsWindowWithHSCard:(HSCard *)hsCard;
- (void)presentDeckDetailsWindowWithLocalDeck:(LocalDeck *)localDeck;
- (void)presentNewPrefsWindow;
- (BOOL)presentNewPrefsWindowIfNeeded;
@end

NS_ASSUME_NONNULL_END
