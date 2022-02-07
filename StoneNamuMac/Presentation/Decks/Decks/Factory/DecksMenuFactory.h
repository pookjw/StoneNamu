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
@property (readonly) SEL keyMenuItemTriggeredSelector;
@property (copy) NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSString *> *> * _Nullable slugsAndNames;
@property (copy) NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSNumber *> *> * _Nullable slugsAndIds;
- (NSMenu *)menuForHSDeckFormat:(HSDeckFormat)deckFormat target:(id _Nullable)target;
@end

NS_ASSUME_NONNULL_END
