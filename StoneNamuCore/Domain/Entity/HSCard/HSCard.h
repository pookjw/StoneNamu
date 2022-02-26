//
//  HSCard.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSCardCollectible.h>
#import <StoneNamuCore/HSCardSort.h>
#import <TargetConditionals.h>

#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#endif

#define kHSCardType @"kHSCardType"
#define HSCARD_LATEST_VERSION 3

NS_ASSUME_NONNULL_BEGIN

#if TARGET_OS_OSX
static NSPasteboardType const NSPasteboardTypeHSCard = @"com.pookjw.StoneNamu.NSPasteboardTypeHSCard";

@interface HSCard : NSObject <NSCopying, NSCoding, NSSecureCoding, NSItemProviderWriting, NSItemProviderReading, NSPasteboardWriting, NSPasteboardReading>
#else
@interface HSCard : NSObject <NSCopying, NSCoding, NSSecureCoding, NSItemProviderWriting, NSItemProviderReading>
#endif
@property (readonly) NSUInteger cardId;
@property (readonly) HSCardCollectible collectible;
@property (readonly, copy) NSString *slug;
@property (readonly, copy) NSNumber * _Nullable classId;
/**
 multiClassIds can be nil, or empty array on old cards...
 */
@property (readonly, copy) NSArray<NSNumber *> * _Nullable multiClassIds;
@property (readonly, copy) NSNumber * _Nullable minionTypeId;
@property (readonly, copy) NSNumber * _Nullable spellSchoolId;
@property (readonly, copy) NSNumber *cardTypeId;
@property (readonly, copy) NSNumber *cardSetId;
@property (readonly, copy) NSNumber * _Nullable rarityId;
@property (readonly, copy) NSString * _Nullable artistName;
@property (readonly) NSUInteger health;
@property (readonly) NSUInteger attack;
@property (readonly) NSUInteger manaCost;
@property (readonly, copy) NSString * _Nullable name;
@property (readonly, copy) NSString *text;
@property (readonly, copy) NSURL *image;
@property (readonly, copy) NSURL * _Nullable imageGold;
@property (readonly, copy) NSString *flavorText;
@property (readonly, copy) NSURL * _Nullable cropImage;
@property (readonly, copy) NSArray<NSNumber *> *childIds;
@property (readonly) NSUInteger parentId;

@property (readonly, copy) NSNumber * _Nullable battlegroundsTier;
@property (readonly, copy) NSNumber * _Nullable battlegroundsHero; // BOOL
@property (readonly, copy) NSURL * _Nullable battlegroundsImage;
@property (readonly, copy) NSURL * _Nullable battlegroundsImageGold;

@property (readonly) NSUInteger version;
@property (class, readonly, nonatomic) NSSet<Class> *unarchvingClasses;
+ (HSCard * _Nullable)hsCardFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error;
+ (NSArray<HSCard *> *)hsCardsFromDic:(NSDictionary *)dic;
- (NSComparisonResult)compare:(HSCard *)other;
@end

NS_ASSUME_NONNULL_END
