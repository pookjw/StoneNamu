//
//  MainSectionModel.h
//  MainSectionModel
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MainSectionModelType) {
    MainSectionModelTypeCards,
    MainSectionModelTypeDeck
};

@interface MainSectionModel : NSObject
@property (readonly) MainSectionModelType type;
@property (readonly, nonatomic) NSString * _Nullable headerText;
@property (readonly, nonatomic) NSString * _Nullable footerText;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(MainSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
