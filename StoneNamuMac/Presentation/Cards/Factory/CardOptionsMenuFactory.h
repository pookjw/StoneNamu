//
//  CardOptionsMenuFactory.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/9/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardOptionsMenuFactory : NSObject
@property (class, readonly) SEL keyMenuItemTriggeredSelector;
+ (BOOL)hasValueForValue:(NSString * _Nullable)value;
+ (NSString * _Nullable)titleForCardOptionTypeWithValue:(NSString * _Nullable)value optionType:(BlizzardHSAPIOptionType)optionType;
+ (NSImage * _Nullable)imageForCardOptionTypeWithValue:(NSString * _Nullable)value optionType:(BlizzardHSAPIOptionType)optionType;
+ (NSMenu *)menuForOptionType:(BlizzardHSAPIOptionType)optionType target:(id<NSSearchFieldDelegate>)target;
@end

NS_ASSUME_NONNULL_END
