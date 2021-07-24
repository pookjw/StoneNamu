//
//  CardOptionsSectionModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardOptionsSectionModelType) {
    CardOptionsSectionModelTypeCard,
    CardOptionsSectionModelTypeSort
};

@interface CardOptionsSectionModel : NSObject
@property (readonly) CardOptionsSectionModelType type;
- (instancetype)initWithType:(CardOptionsSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
