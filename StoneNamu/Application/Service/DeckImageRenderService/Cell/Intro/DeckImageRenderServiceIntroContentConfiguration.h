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
@property (readonly, copy) NSString *deckName;
@property (readonly, copy) HSDeckFormat _Nullable deckFormat;
@property (readonly) BOOL isEasterEgg;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithClassId:(HSCardClass)classId
                       deckName:(NSString *)deckName
                     deckFormat:(HSDeckFormat)deckFormat
                    isEasterEgg:(BOOL)isEasterEgg;
@end

NS_ASSUME_NONNULL_END
