//
//  MainListItemModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/16/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MainListItemModelType) {
    MainListItemModelTypeCards,
    MainListItemModelTypeBattlegrounds,
    MainListItemModelTypeDecks
};

@interface MainListItemModel : NSObject
@property (readonly) MainListItemModelType type;
@property (readonly, nonatomic) NSImage * _Nullable image;
@property (readonly, nonatomic) NSString * _Nullable primaryText;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(MainListItemModelType)type;
@end

NS_ASSUME_NONNULL_END
