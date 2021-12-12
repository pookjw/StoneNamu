//
//  DeckDetailsItemModel.h
//  DeckDetailsItemModel
//
//  Created by Jinwoo Kim on 8/20/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckDetailsItemModelType) {
    DeckDetailsItemModelTypeCost,
    DeckDetailsItemModelTypeCard
};

@interface DeckDetailsItemModel : NSObject <NSCopying>
@property (readonly) DeckDetailsItemModelType type;
@property (copy) HSCard * _Nullable hsCard;
@property (copy) NSNumber * _Nullable hsCardCount;

@property (copy) NSNumber * _Nullable cardManaCost;
@property (copy) NSNumber * _Nullable percentage;
@property (copy) NSNumber * _Nullable cardCount;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DeckDetailsItemModelType)type;
@end

NS_ASSUME_NONNULL_END
