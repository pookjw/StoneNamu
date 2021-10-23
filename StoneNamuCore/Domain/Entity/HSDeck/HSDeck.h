//
//  HSDeck.h
//  HSDeck
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/HSCard.h>
#import <StoneNamuMacCore/HSDeckFormat.h>
#else
#import <StoneNamuCore/HSCard.h>
#import <StoneNamuCore/HSDeckFormat.h>
#endif

#define HSDECK_MAX_TOTAL_CARDS 30
#define HSDECK_MAX_SINGLE_CARD 2
#define HSDECK_MAX_SINGLE_LEGENDARY_CARD 1

NS_ASSUME_NONNULL_BEGIN

@interface HSDeck : NSObject <NSCopying>
@property (readonly, copy) NSString *deckCode;
@property (readonly, copy) HSDeckFormat format;
@property (readonly) HSCardClass classId;
@property (readonly, copy) NSArray<HSCard *> *cards;
+ (HSDeck * _Nullable)hsDeckFromDic:(NSDictionary *)dic error:(NSError ** _Nullable)error;
- (NSString *)localizedDeckCodeWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
