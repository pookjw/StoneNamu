//
//  CardOptionSectionModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardOptionSectionModelType) {
    CardOptionSectionModelTypeMajor,
    CardOptionSectionModelTypeMinor
};

@interface CardOptionSectionModel : NSObject
@property (readonly) CardOptionSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardOptionSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
