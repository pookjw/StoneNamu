//
//  DeckDetailsItemModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckDetailsItemModelType) {
    DeckDetailsItemModelTypeCard
};

@interface DeckDetailsItemModel : NSObject
@property (readonly) DeckDetailsItemModelType type;
@property (copy) HSCard * _Nullable hsCard;
@property (copy) NSNumber * _Nullable hsCardCount;

@property (copy) NSNumber * _Nullable graphManaCost;
@property (copy) NSNumber * _Nullable graphPercentage;
@property (copy) NSNumber * _Nullable graphCount;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DeckDetailsItemModelType)type;
@end

NS_ASSUME_NONNULL_END
