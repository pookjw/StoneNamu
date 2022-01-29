//
//  NSAlert+presentTextFieldAlert.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/29/22.
//

#import "NSAlert+presentTextFieldAlert.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation NSAlert (presentTextFieldAlert)

+ (NSTextField *)presentTextFieldAlertWithMessageText:(NSString *)messageText informativeText:(NSString *)informativeText textFieldText:(NSString * _Nullable)textFieldText target:(id)target action:(SEL)action window:(NSWindow *)window completionHandler:(void (^ _Nullable)(NSModalResponse returnCode))handler {
    NSAlert *alert = [NSAlert new];
    NSButton *doneButton = [alert addButtonWithTitle:[ResourcesService localizationForKey:LocalizableKeyDone]];
    [alert addButtonWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]];
    NSTextField *deckNameTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 300.0f, 20.0f)];
    
    //
    
    doneButton.target = target;
    doneButton.action = action;
    
    //
    
    deckNameTextField.lineBreakMode = NSLineBreakByCharWrapping;
    
    if (textFieldText == nil) {
        deckNameTextField.stringValue = @"";
    } else {
        deckNameTextField.stringValue = textFieldText;
    }
    
    if (messageText == nil) {
        alert.messageText = @"";
    } else {
        alert.messageText = messageText;
    }
    
    if (informativeText == nil) {
        alert.informativeText = @"";
    } else {
        alert.informativeText = informativeText;
    }
    
    alert.showsSuppressionButton = NO;
    alert.accessoryView = deckNameTextField;
    
    //
    
    [alert beginSheetModalForWindow:window completionHandler:handler];
    [alert release];
    
    return [deckNameTextField autorelease];
}

@end
