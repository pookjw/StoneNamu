//
//  HSDeck.h
//  HSDeck
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <Foundation/Foundation.h>
#import "HSCard.h"
#import "HSDeckFormat.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSDeck : NSObject
@property (readonly, copy) NSString *deckCode;
@property (readonly, copy) HSDeckFormat format;
@property (readonly) HSCardClass classId;
@property (readonly, copy) NSArray<HSCard *> *cards;
+ (HSDeck * _Nullable)hsDeckFromDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
