//
//  MainListSectionModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/16/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MainListSectionModelType) {
    MainListSectionModelTypeCards,
    MainListSectionModelTypeDecks
};

@interface MainListSectionModel : NSObject
@property (readonly) MainListSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(MainListSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
