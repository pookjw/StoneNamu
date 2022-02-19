//
//  DeckImageRenderServiceAboutContentConfiguration.h
//  DeckImageRenderServiceAboutContentConfiguration
//
//  Created by Jinwoo Kim on 9/15/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckImageRenderServiceAboutContentConfiguration : NSObject <UIContentConfiguration>
@property (readonly, copy) NSNumber *totalArcaneDust;
@property (readonly, copy) NSString * _Nullable hsYearCurrentName;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTotalArcaneDust:(NSNumber *)totalArcaneDust hsYearCurrentName:(NSString *)hsYearCurrentName;
@end

NS_ASSUME_NONNULL_END
