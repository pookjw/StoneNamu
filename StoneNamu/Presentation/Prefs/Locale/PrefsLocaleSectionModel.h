//
//  PrefsLocaleSectionModel.h
//  PrefsLocaleSectionModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PrefsLocaleSectionModelType) {
    PrefsLocaleSectionModelTypeNoName
};

@interface PrefsLocaleSectionModel : NSObject
@property (readonly) PrefsLocaleSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(PrefsLocaleSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
