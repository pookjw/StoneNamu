//
//  StorableSearchField.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface StorableSearchField : NSSearchField
@property (readonly, copy) NSDictionary * _Nullable userInfo;
- (instancetype)initWithUserInfo:(NSDictionary * _Nullable)userInfo;
@end

NS_ASSUME_NONNULL_END
