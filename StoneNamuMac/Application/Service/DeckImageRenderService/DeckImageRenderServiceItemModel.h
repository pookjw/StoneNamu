//
//  DeckImageRenderServiceItemModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DeckImageRenderServiceItemModelType) {
    DeckImageRenderServiceItemModelTypeIntro,
    DeckImageRenderServiceItemModelTypeCard,
    DeckImageRenderServiceItemModelTypeAbout,
    DeckImageRenderServiceItemModelTypeAppName
};

@interface DeckImageRenderServiceItemModel : NSObject
@property (readonly) DeckImageRenderServiceItemModelType type;

#pragma mark - DeckImageRenderServiceItemModelTypeIntro
@property (copy) NSString * _Nullable classSlug;
@property (copy) NSString * _Nullable className;
@property (copy) NSString * _Nullable deckName;
@property (copy) HSDeckFormat _Nullable deckFormat;
@property BOOL isEasterEgg;

#pragma mark - DeckImageRenderServiceItemModelTypeCard
@property (copy) HSCard * _Nullable hsCard;
@property (retain) NSImage * _Nullable hsCardImage;
@property NSUInteger hsCardCount;
@property (copy) HSCardRaritySlugType _Nullable raritySlug;

#pragma mark - DeckImageRenderServiceSectionModelTypeAppName
@property (copy) NSNumber * _Nullable totalArcaneDust;
@property (copy) NSString * _Nullable hsYearCurrentName;

- (instancetype)initWithType:(DeckImageRenderServiceItemModelType)type;
@end

NS_ASSUME_NONNULL_END
