//
//  DeckAddCardOptionsMenuFactory.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardOptionsMenuFactory : NSObject
@property (class, readonly) SEL keyMenuItemTriggeredSelector;
+ (BOOL)hasValueForValue:(NSString * _Nullable)value;
+ (NSString * _Nullable)titleForDeckAddCardOptionTypeWithValue:(NSString * _Nullable)value optionType:(BlizzardHSAPIOptionType)optionType;
+ (NSImage * _Nullable)imageForDeckAddCardOptionTypeWithValue:(NSString * _Nullable)value optionType:(BlizzardHSAPIOptionType)optionType;
+ (NSMenu *)menuForOptionType:(BlizzardHSAPIOptionType)optionType target:(id<NSSearchFieldDelegate>)target;
@end

NS_ASSUME_NONNULL_END
