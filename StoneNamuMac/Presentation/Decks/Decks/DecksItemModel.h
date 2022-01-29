//
//  DecksItemModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
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
@property BOOL isEasterEgg;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(DecksItemModelType)type localDeck:(LocalDeck *)localDeck isEasterEgg:(BOOL)isEasterEgg;
@end

NS_ASSUME_NONNULL_END
