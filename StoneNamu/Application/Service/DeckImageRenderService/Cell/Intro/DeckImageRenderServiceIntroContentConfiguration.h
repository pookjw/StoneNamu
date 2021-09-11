//
//  DeckImageRenderServiceIntroContentConfiguration.h
//  DeckImageRenderServiceIntroContentConfiguration
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import <UIKit/UIKit.h>
#import "HSCardClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckImageRenderServiceIntroContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly) HSCardClass classId;
@property (readonly, copy) NSNumber *totalArcaneDust;
@property (readonly, copy) NSString *deckName;
@property (readonly, copy) NSString * _Nullable hsYearCurrent;
@property (readonly, copy) HSDeckFormat _Nullable deckFormat;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithClassId:(HSCardClass)classId
                totalArcaneDust:(NSNumber *)totalArcaneDust
                       deckName:(NSString *)deckName
                  hsYearCurrent:(NSString *)hsYearCurrent
                     deckFormat:(HSDeckFormat)deckFormat;
@end

NS_ASSUME_NONNULL_END
