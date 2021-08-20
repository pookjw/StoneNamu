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
    DeckDetailsItemModelTypeCard
};

@interface DeckDetailsItemModel : NSObject
@property (readonly) DeckDetailsItemModelType type;
@property (copy) HSCard * _Nullable hsCard;
- (instancetype)initWithType:(DeckDetailsItemModelType)type;
@end

NS_ASSUME_NONNULL_END