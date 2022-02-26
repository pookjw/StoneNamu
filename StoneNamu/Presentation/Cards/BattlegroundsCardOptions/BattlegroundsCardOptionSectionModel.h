//
//  BattlegroundsCardOptionSectionModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/26/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BattlegroundsCardOptionsSectionModelType) {
    BattlegroundsCardOptionSectionModelTypeFirst,
    BattlegroundsCardOptionSectionModelTypeSecond,
    BattlegroundsCardOptionSectionModelTypeThird,
    BattlegroundsCardOptionSectionModelTypeForth,
    BattlegroundsCardOptionSectionModelTypeFifth
};

@interface BattlegroundsCardOptionSectionModel : NSObject
@property (readonly) BattlegroundsCardOptionsSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(BattlegroundsCardOptionsSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
