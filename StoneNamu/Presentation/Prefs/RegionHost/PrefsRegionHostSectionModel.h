//
//  PrefsRegionHostSectionModel.h
//  PrefsRegionHostSectionModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PrefsRegionHostSectionModelType) {
    PrefsRegionSectionModelTypeNoName
};

@interface PrefsRegionHostSectionModel : NSObject
@property (readonly) PrefsRegionHostSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(PrefsRegionHostSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
