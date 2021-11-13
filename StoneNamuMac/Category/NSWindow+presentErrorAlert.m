//
//  NSWindow+presentErrorAlert.m
//  NSWindow+presentErrorAlert
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "NSWindow+presentErrorAlert.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation NSWindow (presentErrorAlert)

- (void)presentErrorAlertWithError:(NSError *)error {
    [self presentErrorAlertWithError:error completion:nil];
}

- (void)presentErrorAlertWithError:(NSError *)error completion:(void (^ _Nullable)(NSModalResponse returnCode))completion {
    NSAlert *alert = [NSAlert new];
    alert.alertStyle = NSAlertStyleCritical;
    alert.messageText = [ResourcesService localizationForKey:LocalizableKeyErrorAlertTitle];
    alert.informativeText = error.localizedDescription;
    
    [alert beginSheetModalForWindow:self completionHandler:completion];
    [alert autorelease];
}

@end
