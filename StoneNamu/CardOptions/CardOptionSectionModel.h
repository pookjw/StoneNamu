//
//  CardOptionSectionModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardOptionSectionModelType) {
    CardOptionSectionModelTypeCard,
    CardOptionSectionModelTypeSort
};

@interface CardOptionSectionModel : NSObject
@property (readonly) CardOptionSectionModelType type;
- (instancetype)initWithType:(CardOptionSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
