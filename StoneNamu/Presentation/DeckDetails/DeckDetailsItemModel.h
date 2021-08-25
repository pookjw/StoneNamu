//
//  DeckDetailsItemModel.h
//  DeckDetailsItemModel
//
//  Created by Jinwoo Kim on 8/20/21.
//

#import <Foundation/Foundation.h>
#import "HSCard.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckDetailsItemModelType) {
    DeckDetailsItemModelTypeCostGraph,
    DeckDetailsItemModelTypeCard
};

@interface DeckDetailsItemModel : NSObject <NSCopying>
@property (readonly) DeckDetailsItemModelType type;
@property (copy) HSCard * _Nullable hsCard;
@property NSUInteger hsCardCount;
@property (copy) NSDictionary<NSNumber *, NSNumber *> * _Nullable manaDictionary;
- (instancetype)initWithType:(DeckDetailsItemModelType)type;
@end

NS_ASSUME_NONNULL_END
