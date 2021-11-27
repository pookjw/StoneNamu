//
//  DecksMenuFactory.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DecksMenuFactory : NSObject
@property (class, readonly) SEL keyMenuItemTriggeredSelector;
+ (NSMenu *)menuForHSDeckFormat:(HSDeckFormat)deckFormat target:(id _Nullable)target;
@end

NS_ASSUME_NONNULL_END
