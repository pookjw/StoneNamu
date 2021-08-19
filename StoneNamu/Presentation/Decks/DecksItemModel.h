//
//  DecksItemModel.h
//  DecksItemModel
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import <Foundation/Foundation.h>
#import "LocalDeck.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DecksItemModelType) {
    DecksItemModelTypeDeck
};

@interface DecksItemModel : NSObject
@property (readonly) DecksItemModelType type;
@property (readonly, retain) LocalDeck *localDeck;
- (instancetype)initWithType:(DecksItemModelType)type localDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
