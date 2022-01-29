//
//  NSAlert+presentTextFieldAlert.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/29/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAlert (presentTextFieldAlert)
+ (NSTextField *)presentTextFieldAlertWithMessageText:(NSString * _Nullable)messageText informativeText:(NSString * _Nullable)informativeText textFieldText:(NSString * _Nullable)textFieldText target:(id)target action:(SEL)action window:(NSWindow *)window completionHandler:(void (^ _Nullable)(NSModalResponse returnCode))handler;
@end

NS_ASSUME_NONNULL_END
