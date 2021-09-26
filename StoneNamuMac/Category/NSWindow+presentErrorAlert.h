//
//  NSWindow+presentErrorAlert.h
//  NSWindow+presentErrorAlert
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSWindow (presentErrorAlert)
- (void)presentErrorAlertWithError:(NSError *)error;
- (void)presentErrorAlertWithError:(NSError *)error completion:(void (^ _Nullable)(NSModalResponse returnCode))completion;
@end

NS_ASSUME_NONNULL_END
