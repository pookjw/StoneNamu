//
//  DecksItemModel.h
//  DecksItemModel
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DecksItemModelType) {
    DecksItemModelTypeDeck
};

@interface DecksItemModel : NSObject
@property (readonly) DecksItemModelType type;
@property (readonly, retain) LocalDeck *localDeck;
@property (copy) NSString *classSlug;
@property BOOL isEasterEgg;
@property NSUInteger count;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DecksItemModelType)type localDeck:(LocalDeck *)localDeck classSlug:(NSString *)classSlug isEasterEgg:(BOOL)isEasterEgg count:(NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
