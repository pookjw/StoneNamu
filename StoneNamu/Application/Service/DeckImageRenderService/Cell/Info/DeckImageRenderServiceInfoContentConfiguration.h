//
//  DeckImageRenderServiceInfoContentConfiguration.h
//  DeckImageRenderServiceInfoContentConfiguration
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import <UIKit/UIKit.h>
#import "HSDeckFormat.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckImageRenderServiceInfoContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) NSString * _Nullable hsYearCurrent;
@property (readonly, copy) HSDeckFormat _Nullable deckFormat;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSYearCurrent:(NSString *)hsYearCurrent deckFormat:(HSDeckFormat)deckFormat;
@end

NS_ASSUME_NONNULL_END
