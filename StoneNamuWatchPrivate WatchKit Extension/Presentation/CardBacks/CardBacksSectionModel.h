//
//  CardBacksSectionModel.h
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardBacksSectionModelType) {
    CardBacksSectionModelTypeCardBacks
};

@interface CardBacksSectionModel : NSObject
@property (readonly) CardBacksSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardBacksSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
