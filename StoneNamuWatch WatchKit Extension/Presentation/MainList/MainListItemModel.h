//
//  MainListItemModel.h
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/10/22.
//

#import <WatchKit/WatchKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MainListItemModelType) {
    MainListItemModelTypeCardBacks,
    MainListItemModelTypePreferences
};

@interface MainListItemModel : NSObject
@property (readonly) MainListItemModelType type;
- (void)configureWithType:(MainListItemModelType)type;
@end

NS_ASSUME_NONNULL_END
