//
//  CardBacksContentConfiguration.h
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/6/22.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardBacksContentConfiguration : NSObject
@property (readonly, copy) HSCardBack *hsCardBack;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCardBack:(HSCardBack *)hsCardBack;
@end

NS_ASSUME_NONNULL_END
