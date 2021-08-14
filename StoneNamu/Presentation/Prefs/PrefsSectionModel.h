//
//  PrefsSectionModel.h
//  PrefsSectionModel
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PrefsSectionModelType) {
    PrefsSectionModelTypeSearchPrefSelection,
    PrefsSectionModelContributors,
};

@interface PrefsSectionModel : NSObject
@property (readonly) PrefsSectionModelType type;
@property (readonly, nonatomic) NSString * _Nullable headerText;
@property (readonly, nonatomic) NSString * _Nullable footerText;
- (instancetype)initWithType:(PrefsSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
