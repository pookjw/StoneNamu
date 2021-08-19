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
    DeckDetailsItemModelTypeCards
};

@interface DeckDetailsItemModel : NSObject
@property (readonly) DeckDetailsItemModelType type;
@property (copy) NSArray<HSCard *> * _Nullable hsCards;
- (instancetype)initWithType:(DeckDetailsItemModelType)type;
@end

NS_ASSUME_NONNULL_END
