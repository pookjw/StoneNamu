//
//  CardOptionsSearchField.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardOptionsSearchField : NSSearchField
@property (readonly, copy) NSDictionary * _Nullable key;
- (instancetype)initWithKey:(NSDictionary * _Nullable)key;
@end

NS_ASSUME_NONNULL_END
