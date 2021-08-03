//
//  CardSectionModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardsSectionModelType) {
    CardsSectionModelTypeCards
};

@interface CardSectionModel : NSObject
@property (readonly) CardsSectionModelType type;
- (instancetype)initWithType:(CardsSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
