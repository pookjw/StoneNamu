//
//  CardSectionModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardSectionModelType) {
    CardSectionModelTypeCards
};

@interface CardSectionModel : NSObject
@property (readonly) CardSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
