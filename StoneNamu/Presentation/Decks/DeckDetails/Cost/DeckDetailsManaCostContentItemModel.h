//
//  DeckDetailsManaCostContentItemModel.h
//  DeckDetailsManaCostContentItemModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckDetailsManaCostContentItemModelType) {
    DeckDetailsManaCostContentItemModelTypeCostGraph
};

@interface DeckDetailsManaCostContentItemModel : NSObject
@property (readonly) DeckDetailsManaCostContentItemModelType type;
@property (copy) NSNumber * _Nullable cardManaCost;
@property (copy) NSNumber * _Nullable percentage;
@property (copy) NSNumber * _Nullable cardCount;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DeckDetailsManaCostContentItemModelType)type;
@end

NS_ASSUME_NONNULL_END
