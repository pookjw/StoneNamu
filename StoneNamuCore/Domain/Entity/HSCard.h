//
//  HSCard.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <Foundation/Foundation.h>
#import "HSCardClass.h"
#import "HSCardRarity.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSCard : NSObject
@property (readonly) NSInteger id;
@property (readonly) BOOL collectible;
@property (readonly) NSString *slug;
@property (readonly) HSCardClass classId;
@property (readonly) NSArray<NSNumber *> *multiClassIds;
@property (readonly) NSInteger cardSetId;
@property (readonly) HSCardRarity rarityId;
@property (readonly) NSString *artistName;
@property (readonly) NSInteger health;
@property (readonly) NSInteger attack;
@property (readonly) NSInteger manaCost;
@property (readonly) NSString *name;
@property (readonly) NSString *text;
@property (readonly) NSURL *image;
@property (readonly) NSURL * _Nullable imageGold;
@property (readonly) NSString *flavorText;
@property (readonly) NSURL * _Nullable cropImage;
@property (readonly) NSArray<NSNumber *> *childIds;
+ (NSArray<HSCard *> *)hsCardsFromJSONData:(NSData *)data error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
