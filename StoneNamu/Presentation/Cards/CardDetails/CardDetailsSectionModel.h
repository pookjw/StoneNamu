//
//  CardDetailsSectionModel.h
//  CardDetailsSectionModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardDetailsSectionModelType) {
    CardDetailsSectionModelTypeBase,
    CardDetailsSectionModelTypeDetail,
    CardDetailsSectionModelTypeChildren,
};

@interface CardDetailsSectionModel : NSObject
@property (readonly) CardDetailsSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardDetailsSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
